import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import 'events/remove_content_from_watch_list_event.dart';

/// Reusable for both Movie and TV Series
class RemoveContentFromWatchListBloc<ContentType extends Object>
    extends Bloc<RemoveContentFromWatchListEvent, GetAsyncDataState> {
  RemoveContentFromWatchListBloc()
      : super(
          GetAsyncDataInitialState(),
        ) {
    on<RemoveContentFromWatchListEvent>(
      ((event, emit) async {
        emit(GetAsyncDataLoadingState());
        final result = await removeFromWatchList(
          event.content,
        );
        result.fold(
          (failure) async {
            emit(
              GetAsyncDataErrorState(
                message: failure.message,
              ),
            );
          },
          (successMessage) async {
            emit(
              GetAsyncDataLoadedState<String>(
                data: successMessage,
              ),
            );
          },
        );
      }),
    );
  }

  Future<Either<Failure, String>> removeFromWatchList(
      ContentType content) async {
    return const Right('default_value');
  }
}
