import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watch_list/domain/use_cases/remove_movie_watch_list.dart';
import 'package:watch_list/domain/use_cases/remove_tv_series_watch_list.dart';
import 'package:watch_list/presentation/bloc/events/remove_content_from_watch_list_event.dart';
import 'package:watch_list/presentation/bloc/movie/remove_movie_from_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/remove_tv_series_from_watch_list_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'remove_content_from_watch_list_bloc_test.mocks.dart';

@GenerateMocks([
  RemoveMovieWatchList,
  RemoveTvSeriesWatchList,
])
void main() {
  late RemoveMovieFromWatchListBloc removeMovieFromWatchListBloc;
  late RemoveTvSeriesFromWatchListBloc removeTvSeriesFromWatchListBloc;

  late MockRemoveMovieWatchList mockRemoveMovieWatchList;
  late MockRemoveTvSeriesWatchList mockRemoveTvSeriesWatchList;

  setUp(
    () {
      mockRemoveMovieWatchList = MockRemoveMovieWatchList();
      mockRemoveTvSeriesWatchList = MockRemoveTvSeriesWatchList();

      removeMovieFromWatchListBloc = RemoveMovieFromWatchListBloc(
        removeMovieWatchList: mockRemoveMovieWatchList,
      );
      removeTvSeriesFromWatchListBloc = RemoveTvSeriesFromWatchListBloc(
        removeTvSeriesWatchList: mockRemoveTvSeriesWatchList,
      );
    },
  );

  group(
    'remove movie to watch list',
    () {
      blocTest<RemoveMovieFromWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [RemoveContentFromWatchListEvent] event is added',
        build: () {
          when(
            mockRemoveMovieWatchList.execute(testMovieDetail),
          ).thenAnswer(
            (_) async => const Right('success_message'),
          );
          return removeMovieFromWatchListBloc;
        },
        act: (bloc) => bloc.add(
          RemoveContentFromWatchListEvent(
            content: testMovieDetail,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: 'success_message',
          ),
        ],
        verify: (bloc) {
          verify(
            mockRemoveMovieWatchList.execute(testMovieDetail),
          );
        },
      );

      blocTest<RemoveMovieFromWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [RemoveContentFromWatchListEvent] event is added',
        build: () {
          when(
            mockRemoveMovieWatchList.execute(testMovieDetail),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return removeMovieFromWatchListBloc;
        },
        act: (bloc) => bloc.add(
          RemoveContentFromWatchListEvent(
            content: testMovieDetail,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occurred',
          ),
        ],
        verify: (bloc) {
          verify(
            mockRemoveMovieWatchList.execute(testMovieDetail),
          );
        },
      );
    },
  );

  group(
    'remove tv series to watch list',
    () {
      blocTest<RemoveTvSeriesFromWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [RemoveContentFromWatchListEvent] event is added',
        build: () {
          when(
            mockRemoveTvSeriesWatchList.execute(testTvSeriesDetail),
          ).thenAnswer(
            (_) async => const Right('success_message'),
          );
          return removeTvSeriesFromWatchListBloc;
        },
        act: (bloc) => bloc.add(
          RemoveContentFromWatchListEvent(
            content: testTvSeriesDetail,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: 'success_message',
          ),
        ],
        verify: (bloc) {
          verify(
            mockRemoveTvSeriesWatchList.execute(testTvSeriesDetail),
          );
        },
      );

      blocTest<RemoveTvSeriesFromWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [RemoveContentFromWatchListEvent] event is added',
        build: () {
          when(
            mockRemoveTvSeriesWatchList.execute(testTvSeriesDetail),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return removeTvSeriesFromWatchListBloc;
        },
        act: (bloc) => bloc.add(
          RemoveContentFromWatchListEvent(
            content: testTvSeriesDetail,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occurred',
          ),
        ],
        verify: (bloc) {
          verify(
            mockRemoveTvSeriesWatchList.execute(testTvSeriesDetail),
          );
        },
      );
    },
  );
}
