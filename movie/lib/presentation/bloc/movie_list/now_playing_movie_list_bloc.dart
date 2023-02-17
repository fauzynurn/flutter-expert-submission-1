import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_now_playing_movies.dart';
import 'events/get_movie_list_event.dart';

class NowPlayingMovieListBloc
    extends Bloc<GetMovieListEvent, GetAsyncDataState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieListBloc({
    required this.getNowPlayingMovies,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetMovieListEvent>(
      ((event, emit) async {
        emit(GetAsyncDataLoadingState());
        final result = await getNowPlayingMovies.execute();
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
