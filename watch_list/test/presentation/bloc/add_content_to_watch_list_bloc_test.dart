import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watch_list/domain/use_cases/save_movie_watch_list.dart';
import 'package:watch_list/domain/use_cases/save_tv_series_watch_list.dart';
import 'package:watch_list/presentation/bloc/events/add_content_to_watch_list_event.dart';
import 'package:watch_list/presentation/bloc/movie/add_movie_to_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/add_tv_series_to_watch_list_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'add_to_watch_list_bloc_test.mocks.dart';

@GenerateMocks([
  SaveMovieWatchList,
  SaveTvSeriesWatchList,
])
void main() {
  late AddMovieToWatchListBloc addMovieToWatchListBloc;
  late AddTvSeriesToWatchListBloc addTvSeriesToWatchListBloc;

  late MockSaveMovieWatchList mockSaveMovieWatchList;
  late MockSaveTvSeriesWatchList mockSaveTvSeriesWatchList;

  setUp(
    () {
      mockSaveMovieWatchList = MockSaveMovieWatchList();
      mockSaveTvSeriesWatchList = MockSaveTvSeriesWatchList();

      addMovieToWatchListBloc = AddMovieToWatchListBloc(
        saveMovieWatchList: mockSaveMovieWatchList,
      );
      addTvSeriesToWatchListBloc = AddTvSeriesToWatchListBloc(
        saveTvSeriesWatchList: mockSaveTvSeriesWatchList,
      );
    },
  );

  group(
    'Save movie to watch list',
    () {
      blocTest<AddMovieToWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [AddContentToWatchListEvent] event is added',
        build: () {
          when(
            mockSaveMovieWatchList.execute(testMovieDetail),
          ).thenAnswer(
            (_) async => const Right('success_message'),
          );
          return addMovieToWatchListBloc;
        },
        act: (bloc) => bloc.add(
          const AddContentToWatchListEvent(
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
            mockSaveMovieWatchList.execute(testMovieDetail),
          );
        },
      );

      blocTest<AddMovieToWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [AddContentToWatchListEvent] event is added',
        build: () {
          when(
            mockSaveMovieWatchList.execute(testMovieDetail),
          ).thenAnswer(
            (_) async => const Left(
              ServerFailure('A server error occured'),
            ),
          );
          return addMovieToWatchListBloc;
        },
        act: (bloc) => bloc.add(
          const AddContentToWatchListEvent(
            content: testMovieDetail,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occured',
          ),
        ],
        verify: (bloc) {
          verify(
            mockSaveMovieWatchList.execute(testMovieDetail),
          );
        },
      );
    },
  );

  group(
    'Save tv series to watch list',
    () {
      blocTest<AddTvSeriesToWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [AddContentToWatchListEvent] event is added',
        build: () {
          when(
            mockSaveTvSeriesWatchList.execute(testTvSeriesDetail),
          ).thenAnswer(
            (_) async => const Right('success_message'),
          );
          return addTvSeriesToWatchListBloc;
        },
        act: (bloc) => bloc.add(
          const AddContentToWatchListEvent(
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
            mockSaveTvSeriesWatchList.execute(testTvSeriesDetail),
          );
        },
      );

      blocTest<AddTvSeriesToWatchListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [AddContentToWatchListEvent] event is added',
        build: () {
          when(
            mockSaveTvSeriesWatchList.execute(testTvSeriesDetail),
          ).thenAnswer(
            (_) async => const Left(
              ServerFailure('A server error occured'),
            ),
          );
          return addTvSeriesToWatchListBloc;
        },
        act: (bloc) => bloc.add(
          const AddContentToWatchListEvent(
            content: testTvSeriesDetail,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occured',
          ),
        ],
        verify: (bloc) {
          verify(
            mockSaveTvSeriesWatchList.execute(testTvSeriesDetail),
          );
        },
      );
    },
  );
}
