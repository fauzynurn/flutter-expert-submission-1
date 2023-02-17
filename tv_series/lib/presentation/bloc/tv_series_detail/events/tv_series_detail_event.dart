import 'package:core/presentation/bloc/get_async_data/get_async_data_event.dart';

class TvSeriesDetailEvent extends GetAsyncDataEvent {}

class GetTvSeriesDetailDataEvent extends TvSeriesDetailEvent {
  final int id;

  GetTvSeriesDetailDataEvent({
    required this.id,
  });
}

class GetRecommendationTvSeriesDataEvent extends TvSeriesDetailEvent {
  final int id;

  GetRecommendationTvSeriesDataEvent({
    required this.id,
  });
}
