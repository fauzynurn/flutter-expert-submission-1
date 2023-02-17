import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_tv_series_recommendations.dart';
import 'events/tv_series_detail_event.dart';

class TvSeriesRecommendationBloc
    extends Bloc<TvSeriesDetailEvent, GetAsyncDataState> {
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesRecommendationBloc({
    required this.getTvSeriesRecommendations,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetRecommendationTvSeriesDataEvent>(
      ((event, emit) async {
        final id = event.id;
        emit(GetAsyncDataLoadingState());
        final result = await getTvSeriesRecommendations.execute(id);
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
