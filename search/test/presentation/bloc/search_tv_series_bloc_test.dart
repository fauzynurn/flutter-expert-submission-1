import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/use_cases/search_tv_series.dart';
import 'package:search/presentation/bloc/events/get_search_result_event.dart';
import 'package:search/presentation/bloc/events/reset_search_result_event.dart';
import 'package:search/presentation/bloc/search_tv_series_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  SearchTvSeries,
])
void main() {
  late SearchTvSeriesBloc searchTvSeriesBloc;

  late MockSearchTvSeries mockSearchTvSeries;

  const query = 'query';

  setUp(
    () {
      mockSearchTvSeries = MockSearchTvSeries();

      searchTvSeriesBloc = SearchTvSeriesBloc(
        searchTvSeries: mockSearchTvSeries,
      );
    },
  );

  group(
    'Get Tv Series Search Result',
    () {
      blocTest<SearchTvSeriesBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetSearchResultEvent] event is added',
        build: () {
          when(
            mockSearchTvSeries.execute(query),
          ).thenAnswer(
            (_) async => Right(testTvSeriesList),
          );
          return searchTvSeriesBloc;
        },
        act: (bloc) => bloc.add(
          GetSearchResultEvent(
            query: query,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: testTvSeriesList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockSearchTvSeries.execute(query),
          );
        },
      );
      blocTest<SearchTvSeriesBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetSearchResultEvent] event is added',
        build: () {
          when(
            mockSearchTvSeries.execute(query),
          ).thenAnswer(
            (_) async => const Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return searchTvSeriesBloc;
        },
        act: (bloc) => bloc.add(
          GetSearchResultEvent(
            query: query,
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
            mockSearchTvSeries.execute(query),
          );
        },
      );
    },
  );

  group(
    'Reset Tv Series Search Result',
    () {
      blocTest<SearchTvSeriesBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [ResetSearchResultEvent] event is added',
        build: () {
          return searchTvSeriesBloc;
        },
        act: (bloc) => bloc.add(
          ResetSearchResultEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadedState(
            data: const [],
          ),
        ],
      );
    },
  );
}
