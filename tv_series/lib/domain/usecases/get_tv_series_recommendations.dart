import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';

import 'package:core/domain/repositories/tv_series_repository.dart';

class GetTvSeriesRecommendations {
  final TvSeriesRepository repository;

  GetTvSeriesRecommendations(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(id) {
    return repository.getTvSeriesRecommendations(id);
  }
}
