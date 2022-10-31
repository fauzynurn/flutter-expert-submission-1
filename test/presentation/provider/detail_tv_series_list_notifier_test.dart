import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/detail_list_type.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/detail_tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'detail_tv_series_list_notifier_test.mocks.dart';

@GenerateMocks(
  [
    GetPopularTvSeries,
    GetNowPlayingTvSeries,
    GetTopRatedTvSeries,
  ],
)
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late DetailTvSeriesListNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    notifier = DetailTvSeriesListNotifier(
      getPopularTvSeries: mockGetPopularTvSeries,
      getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));
    // act
    notifier.fetchTvSeries(
      detailListType: DetailListType.popular,
    );
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test(
    'should change tv series data when data is gotten successfully (popular)',
    () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await notifier.fetchTvSeries(
        detailListType: DetailListType.popular,
      );
      // assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tvSeries, tTvSeriesList);
      expect(listenerCallCount, 2);
    },
  );

  test(
    'should change tv series data when data is gotten successfully (now playing)',
    () async {
      // arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await notifier.fetchTvSeries(
        detailListType: DetailListType.nowPlaying,
      );
      // assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tvSeries, tTvSeriesList);
      expect(listenerCallCount, 2);
    },
  );

  test(
    'should change tv series data when data is gotten successfully (top rated)',
    () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await notifier.fetchTvSeries(
        detailListType: DetailListType.topRated,
      );
      // assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tvSeries, tTvSeriesList);
      expect(listenerCallCount, 2);
    },
  );

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTvSeries(
      detailListType: DetailListType.popular,
    );
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
