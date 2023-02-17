import 'package:core/domain/entities/tv_series.dart';
import 'package:core/helper/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/use_cases/get_now_playing_tv_series.dart';

void main() {
  late GetNowPlayingTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetNowPlayingTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  test(
    'should get list of tv series from the repository',
    () async {
      // arrange
      when(
        mockTvSeriesRepository.getNowPlayingTvSeries(),
      ).thenAnswer(
        (_) async => Right(tTvSeries),
      );
      // act
      final result = await useCase.execute();
      // assert
      expect(
        result,
        Right(tTvSeries),
      );
    },
  );
}
