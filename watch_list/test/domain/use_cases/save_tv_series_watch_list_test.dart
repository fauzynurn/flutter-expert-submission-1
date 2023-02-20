import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watch_list/domain/use_cases/save_tv_series_watch_list.dart';

import '../../dummy_data/dummy_objects.dart';
import 'package:core/helper/test_helper.mocks.dart';

void main() {
  late SaveTvSeriesWatchList useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = SaveTvSeriesWatchList(mockTvSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail),
    ).thenAnswer(
      (_) async => const Right('Added to Watchlist'),
    );
    // act
    final result = await useCase.execute(testTvSeriesDetail);
    // assert
    verify(
      mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail),
    );
    expect(
      result,
      const Right('Added to Watchlist'),
    );
  });
}
