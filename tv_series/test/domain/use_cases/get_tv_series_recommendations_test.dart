import 'package:core/domain/entities/tv_series.dart';
import 'package:core/helper/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/use_cases/get_tv_series_recommendations.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockTvSeriesRepository);
  });

  const tId = 1;
  final tTvSeries = <TvSeries>[];

  test(
    'should get list of tv series recommendations from the repository',
    () async {
      // arrange
      when(
        mockTvSeriesRepository.getTvSeriesRecommendations(tId),
      ).thenAnswer(
        (_) async => Right(tTvSeries),
      );
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(
        result,
        Right(tTvSeries),
      );
    },
  );
}