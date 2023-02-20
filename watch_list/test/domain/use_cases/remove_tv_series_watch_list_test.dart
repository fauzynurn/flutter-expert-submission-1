import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watch_list/domain/use_cases/remove_tv_series_watch_list.dart';

import '../../dummy_data/dummy_objects.dart';
import 'package:core/helper/test_helper.mocks.dart';

void main() {
  late RemoveTvSeriesWatchList useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = RemoveTvSeriesWatchList(mockTvSeriesRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail),
    ).thenAnswer(
      (_) async => const Right('Removed from watchlist'),
    );
    // act
    final result = await useCase.execute(testTvSeriesDetail);
    // assert
    verify(
      mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail),
    );
    expect(
      result,
      const Right('Removed from watchlist'),
    );
  });
}
