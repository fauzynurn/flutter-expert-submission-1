import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:search/domain/use_cases/search_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/bloc/events/get_search_result_event.dart';
import 'package:search/presentation/bloc/events/reset_search_result_event.dart';
import 'package:search/presentation/bloc/search_movie_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_movie_bloc_test.mocks.dart';

@GenerateMocks([
  SearchMovie,
])
void main() {
  late SearchMovieBloc searchMovieBloc;

  late MockSearchMovie mockSearchMovie;

  const query = 'query';

  setUp(
    () {
      mockSearchMovie = MockSearchMovie();

      searchMovieBloc = SearchMovieBloc(
        searchMovie: mockSearchMovie,
      );
    },
  );

  group(
    'Get Movie Search Result',
    () {
      blocTest<SearchMovieBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetSearchResultEvent] event is added',
        build: () {
          when(
            mockSearchMovie.execute(query),
          ).thenAnswer(
            (_) async => Right(testMovieList),
          );
          return searchMovieBloc;
        },
        act: (bloc) => bloc.add(
          GetSearchResultEvent(
            query: query,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: testMovieList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockSearchMovie.execute(query),
          );
        },
      );
      blocTest<SearchMovieBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetSearchResultEvent] event is added',
        build: () {
          when(
            mockSearchMovie.execute(query),
          ).thenAnswer(
            (_) async => const Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return searchMovieBloc;
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
            mockSearchMovie.execute(query),
          );
        },
      );
    },
  );

  group(
    'Reset Movie Search Result',
    () {
      blocTest<SearchMovieBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [ResetSearchResultEvent] event is added',
        build: () {
          return searchMovieBloc;
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
