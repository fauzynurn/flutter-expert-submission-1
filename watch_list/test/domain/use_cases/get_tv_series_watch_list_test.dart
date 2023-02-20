import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list.dart';

import '../../dummy_data/dummy_objects.dart';
import 'package:core/helper/test_helper.mocks.dart';

void main() {
  late GetTvSeriesWatchList useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetTvSeriesWatchList(mockTvSeriesRepository);
  });

  test('should get list of tv series from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getWatchlistTvSeries(),
    ).thenAnswer(
      (_) async => Right(testTvSeriesList),
    );
    // act
    final result = await useCase.execute();
    // assert
    expect(result, Right(testTvSeriesList));
  });
}
