import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/use_cases/search_tv_series.dart';

import 'package:core/helper/test_helper.mocks.dart';

void main() {
  late SearchTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = SearchTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];
  const tQuery = 'query';

  test('should get list of tv series from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.searchTvSeries(tQuery),
    ).thenAnswer(
      (_) async => Right(tTvSeries),
    );
    // act
    final result = await useCase.execute(tQuery);
    // assert
    expect(
      result,
      Right(tTvSeries),
    );
  });
}
