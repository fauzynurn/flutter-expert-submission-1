import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_movie_recommendations.dart';
import 'events/movie_detail_event.dart';

class MovieRecommendationBloc
    extends Bloc<MovieDetailEvent, GetAsyncDataState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc({
    required this.getMovieRecommendations,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetRecommendationMovieDataEvent>(
      ((event, emit) async {
        final id = event.id;
        emit(GetAsyncDataLoadingState());
        final result = await getMovieRecommendations.execute(id);
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
