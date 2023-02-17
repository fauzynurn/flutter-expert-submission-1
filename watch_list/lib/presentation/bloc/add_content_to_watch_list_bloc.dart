import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import 'events/add_content_to_watch_list_event.dart';

/// Reusable for both Movie and TV Series
class AddContentToWatchList<ContentType extends Object>
    extends Bloc<AddContentToWatchListEvent, GetAsyncDataState> {
  AddContentToWatchList()
      : super(
          GetAsyncDataInitialState(),
        ) {
    on<AddContentToWatchListEvent>(
      ((event, emit) async {
        emit(GetAsyncDataLoadingState());
        final result = await addToWatchlist(
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

  Future<Either<Failure, String>> addToWatchlist(ContentType content) async {
    return const Right('default_value');
  }
}
