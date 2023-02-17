import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_movie_watch_list.dart';
import '../events/get_watch_list_event.dart';

class GetMovieWatchListBloc extends Bloc<GetWatchListEvent, GetAsyncDataState> {
  final GetMovieWatchList getMovieWatchlist;

  GetMovieWatchListBloc({
    required this.getMovieWatchlist,
  }) : super(
    GetAsyncDataInitialState(),
  ) {
    on<GetWatchListEvent>(
      ((event, emit) async {
        emit(GetAsyncDataLoadingState());
        final result = await getMovieWatchlist.execute();
        result.fold(
              (failure) {
            emit(
              GetAsyncDataErrorState(
                message: failure.message,
              ),
            );
          },
              (data) {
            emit(
              GetAsyncDataLoadedState(
                data: data,
              ),
            );
          },
        );
      }),
    );
  }
}
