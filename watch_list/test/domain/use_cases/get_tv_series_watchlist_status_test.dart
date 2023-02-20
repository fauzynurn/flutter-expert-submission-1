import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list_status.dart';

import 'package:core/helper/test_helper.mocks.dart';

void main() {
  late GetTvSeriesWatchListStatus useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetTvSeriesWatchListStatus(mockTvSeriesRepository);
  });

  test('should get tv series watchlist status from repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.isAddedToWatchlist(1),
    ).thenAnswer((_) async => true);
    // act
    final result = await useCase.execute(1);
    // assert
    expect(result, true);
  });
}
