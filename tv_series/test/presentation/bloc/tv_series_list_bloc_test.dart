import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/use_cases/get_now_playing_tv_series.dart';
import 'package:tv_series/domain/use_cases/get_popular_tv_series.dart';
import 'package:tv_series/domain/use_cases/get_top_rated_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/events/get_tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/now_playing_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/popular_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/top_rated_tv_series_list_bloc.dart';

import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTvSeries,
  GetPopularTvSeries,
  GetTopRatedTvSeries,
])
void main() {
  late NowPlayingTvSeriesListBloc nowPlayingTvSeriesBloc;
  late PopularTvSeriesListBloc popularTvSeriesBloc;
  late TopRatedTvSeriesListBloc topRatedBloc;

  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(
    () {
      mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
      mockGetPopularTvSeries = MockGetPopularTvSeries();
      mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();

      nowPlayingTvSeriesBloc = NowPlayingTvSeriesListBloc(
        getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
      );
      popularTvSeriesBloc = PopularTvSeriesListBloc(
        getPopularTvSeries: mockGetPopularTvSeries,
      );
      topRatedBloc = TopRatedTvSeriesListBloc(
        getTopRatedTvSeries: mockGetTopRatedTvSeries,
      );
    },
  );

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'releaseDate',
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group(
    'Now playing tv series test',
    () {
      blocTest<NowPlayingTvSeriesListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetTvSeriesList] event is added',
        build: () {
          when(
            mockGetNowPlayingTvSeries.execute(),
          ).thenAnswer(
            (_) async => Right(tTvSeriesList),
          );
          return nowPlayingTvSeriesBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: tTvSeriesList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetNowPlayingTvSeries.execute(),
          );
        },
      );

      blocTest<NowPlayingTvSeriesListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetTvSeriesList] event is added',
        build: () {
          when(
            mockGetNowPlayingTvSeries.execute(),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return nowPlayingTvSeriesBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occurred',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetNowPlayingTvSeries.execute(),
          );
        },
      );
    },
  );

  group(
    'Popular tv series test',
    () {
      blocTest<PopularTvSeriesListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetTvSeriesList] event is added',
        build: () {
          when(
            mockGetPopularTvSeries.execute(),
          ).thenAnswer(
            (_) async => Right(tTvSeriesList),
          );
          return popularTvSeriesBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: tTvSeriesList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetPopularTvSeries.execute(),
          );
        },
      );

      blocTest<PopularTvSeriesListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetTvSeriesList] event is added',
        build: () {
          when(
            mockGetPopularTvSeries.execute(),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return popularTvSeriesBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occurred',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetPopularTvSeries.execute(),
          );
        },
      );
    },
  );

  group(
    'Top Rated tv series test',
    () {
      blocTest<TopRatedTvSeriesListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetTvSeriesList] event is added',
        build: () {
          when(
            mockGetTopRatedTvSeries.execute(),
          ).thenAnswer(
            (_) async => Right(tTvSeriesList),
          );
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: tTvSeriesList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTopRatedTvSeries.execute(),
          );
        },
      );

      blocTest<TopRatedTvSeriesListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetTvSeriesList] event is added',
        build: () {
          when(
            mockGetTopRatedTvSeries.execute(),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occurred',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTopRatedTvSeries.execute(),
          );
        },
      );
    },
  );

  // group('popular tv seriess', () {
  //   test('should change state to loading when usecase is called', () async {
  //     // arrange
  //     when(mockGetPopularTvSeries.execute())
  //         .thenAnswer((_) async => Right(tTvSeriesList));
  //     // act
  //     provider.fetchPopularTvSeries();
  //     // assert
  //     expect(provider.popularTvSeriesState, RequestState.loading);
  //     // verify(provider.setState(RequestState.loading));
  //   });

  //   test('should change tv seriess data when data is gotten successfully',
  //       () async {
  //     // arrange
  //     when(mockGetPopularTvSeries.execute())
  //         .thenAnswer((_) async => Right(tTvSeriesList));
  //     // act
  //     await provider.fetchPopularTvSeries();
  //     // assert
  //     expect(provider.popularTvSeriesState, RequestState.loaded);
  //     expect(provider.popularTvSeries, tTvSeriesList);
  //     expect(listenerCallCount, 2);
  //   });

  //   test('should return error when data is unsuccessful', () async {
  //     // arrange
  //     when(mockGetPopularTvSeries.execute())
  //         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //     // act
  //     await provider.fetchPopularTvSeries();
  //     // assert
  //     expect(provider.popularTvSeriesState, RequestState.error);
  //     expect(provider.message, 'Server Failure');
  //     expect(listenerCallCount, 2);
  //   });
  // });

  // group('top rated tv seriess', () {
  //   test('should change state to loading when usecase is called', () async {
  //     // arrange
  //     when(mockGetTopRatedTvSeries.execute())
  //         .thenAnswer((_) async => Right(tTvSeriesList));
  //     // act
  //     provider.fetchTopRatedTvSeries();
  //     // assert
  //     expect(provider.topRatedTvSeriesState, RequestState.loading);
  //   });

  //   test('should change tv seriess data when data is gotten successfully',
  //       () async {
  //     // arrange
  //     when(mockGetTopRatedTvSeries.execute())
  //         .thenAnswer((_) async => Right(tTvSeriesList));
  //     // act
  //     await provider.fetchTopRatedTvSeries();
  //     // assert
  //     expect(provider.topRatedTvSeriesState, RequestState.loaded);
  //     expect(provider.topRatedTvSeries, tTvSeriesList);
  //     expect(listenerCallCount, 2);
  //   });

  //   test('should return error when data is unsuccessful', () async {
  //     // arrange
  //     when(mockGetTopRatedTvSeries.execute())
  //         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //     // act
  //     await provider.fetchTopRatedTvSeries();
  //     // assert
  //     expect(provider.topRatedTvSeriesState, RequestState.error);
  //     expect(provider.message, 'Server Failure');
  //     expect(listenerCallCount, 2);
  //   });
  // });
}
