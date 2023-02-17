import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/use_cases/get_movie_detail.dart';
import 'package:movie/domain/use_cases/get_movie_recommendations.dart';
import 'package:movie/presentation/bloc/movie_detail/events/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_recommendation_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MovieRecommendationBloc movieRecommendationBloc;

  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();

    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
    );
    movieRecommendationBloc = MovieRecommendationBloc(
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  const tId = 1;

  group(
    'Get Movie Detail',
    () {
      blocTest<MovieDetailBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetMovieDetailDataEvent] event is added',
        build: () {
          when(
            mockGetMovieDetail.execute(tId),
          ).thenAnswer(
            (_) async => Right(testMovieDetail),
          );
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieDetailDataEvent(
            id: tId,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: testMovieDetail,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetMovieDetail.execute(tId),
          );
        },
      );
      blocTest<MovieDetailBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetMovieDetailDataEvent] event is added',
        build: () {
          when(
            mockGetMovieDetail.execute(tId),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieDetailDataEvent(
            id: tId,
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
            mockGetMovieDetail.execute(tId),
          );
        },
      );
    },
  );

  group(
    'Get Movie Recommendation',
    () {
      blocTest<MovieRecommendationBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetRecommendationMovieDataEvent] event is added',
        build: () {
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(testMovieList));
          return movieRecommendationBloc;
        },
        act: (bloc) => bloc.add(
          GetRecommendationMovieDataEvent(
            id: tId,
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
            mockGetMovieRecommendations.execute(tId),
          );
        },
      );
      blocTest<MovieRecommendationBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetRecommendationMovieDataEvent] event is added',
        build: () {
          when(
            mockGetMovieRecommendations.execute(tId),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return movieRecommendationBloc;
        },
        act: (bloc) => bloc.add(
          GetRecommendationMovieDataEvent(
            id: tId,
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
            mockGetMovieRecommendations.execute(tId),
          );
        },
      );
    },
  );
}
