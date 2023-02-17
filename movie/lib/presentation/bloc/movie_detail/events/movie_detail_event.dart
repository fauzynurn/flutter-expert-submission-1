import 'package:core/presentation/bloc/get_async_data/get_async_data_event.dart';

class MovieDetailEvent extends GetAsyncDataEvent {}

class GetMovieDetailDataEvent extends MovieDetailEvent {
  final int id;

  GetMovieDetailDataEvent({
    required this.id,
  });
}

class GetRecommendationMovieDataEvent extends MovieDetailEvent {
  final int id;

  GetRecommendationMovieDataEvent({
    required this.id,
  });
}
