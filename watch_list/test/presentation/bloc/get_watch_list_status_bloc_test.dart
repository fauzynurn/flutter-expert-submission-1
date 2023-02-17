import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watch_list/domain/use_cases/get_movie_watch_list_status.dart';
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list_status.dart';
import 'package:watch_list/presentation/bloc/events/watch_list_status_event.dart';
import 'package:watch_list/presentation/bloc/get_watch_list_status_bloc.dart';

import 'get_watch_list_status_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieWatchListStatus,
  GetTvSeriesWatchListStatus,
])
void main() {
  late GetWatchListStatusBloc getWatchListStatusBloc;

  late MockGetMovieWatchListStatus mockGetMovieWatchListStatus;
  late MockGetTvSeriesWatchListStatus mockGetTvSeriesWatchListStatus;

  setUp(
    () {
      mockGetMovieWatchListStatus = MockGetMovieWatchListStatus();
      mockGetTvSeriesWatchListStatus = MockGetTvSeriesWatchListStatus();

      getWatchListStatusBloc = GetWatchListStatusBloc(
        getMovieWatchListStatus: mockGetMovieWatchListStatus,
        getTvSeriesWatchListStatus: mockGetTvSeriesWatchListStatus,
      );
    },
  );

  const tId = 1;

  group(
    'Get movie watch list status',
    () {
      blocTest<GetWatchListStatusBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState with true value] when [WatchListStatusEvent] event is added',
        build: () {
          when(
            mockGetMovieWatchListStatus.execute(tId),
          ).thenAnswer(
            (_) async => true,
          );
          return getWatchListStatusBloc;
        },
        act: (bloc) => bloc.add(
          const WatchListStatusEvent(
            id: tId,
            type: FilterType.movies,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: true,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetMovieWatchListStatus.execute(tId),
          );
        },
      );

      blocTest<GetWatchListStatusBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState with false value] when [WatchListStatusEvent] event is added',
        build: () {
          when(
            mockGetMovieWatchListStatus.execute(tId),
          ).thenAnswer(
            (_) async => false,
          );
          return getWatchListStatusBloc;
        },
        act: (bloc) => bloc.add(
          const WatchListStatusEvent(
            id: tId,
            type: FilterType.movies,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: false,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetMovieWatchListStatus.execute(tId),
          );
        },
      );
    },
  );

  group(
    'Get tv series watch list status',
    () {
      blocTest<GetWatchListStatusBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState with true value] when [WatchListStatusEvent] event is added',
        build: () {
          when(
            mockGetTvSeriesWatchListStatus.execute(tId),
          ).thenAnswer(
            (_) async => true,
          );
          return getWatchListStatusBloc;
        },
        act: (bloc) => bloc.add(
          const WatchListStatusEvent(
            id: tId,
            type: FilterType.tvSeries,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: true,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTvSeriesWatchListStatus.execute(tId),
          );
        },
      );

      blocTest<GetWatchListStatusBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState with false value] when [WatchListStatusEvent] event is added',
        build: () {
          when(
            mockGetTvSeriesWatchListStatus.execute(tId),
          ).thenAnswer(
            (_) async => false,
          );
          return getWatchListStatusBloc;
        },
        act: (bloc) => bloc.add(
          const WatchListStatusEvent(
            id: tId,
            type: FilterType.tvSeries,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: false,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTvSeriesWatchListStatus.execute(tId),
          );
        },
      );
    },
  );
}
