import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_top_rated_movies.dart';
import 'events/get_movie_list_event.dart';

class TopRatedMovieListBloc extends Bloc<GetMovieListEvent, GetAsyncDataState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMovieListBloc({
    required this.getTopRatedMovies,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetMovieListEvent>(
      ((event, emit) async {
        emit(GetAsyncDataLoadingState());
        final result = await getTopRatedMovies.execute();
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
