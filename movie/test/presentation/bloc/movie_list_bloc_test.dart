import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie/domain/use_cases/get_popular_movies.dart';
import 'package:movie/domain/use_cases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_list/events/get_movie_list_event.dart';
import 'package:movie/presentation/bloc/movie_list/now_playing_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/popular_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/top_rated_movie_list_bloc.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late NowPlayingMovieListBloc nowPlayingBloc;
  late PopularMovieListBloc popularMovieBloc;
  late TopRatedMovieListBloc topRatedBloc;

  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(
    () {
      mockGetNowPlayingMovies = MockGetNowPlayingMovies();
      mockGetPopularMovies = MockGetPopularMovies();
      mockGetTopRatedMovies = MockGetTopRatedMovies();

      nowPlayingBloc = NowPlayingMovieListBloc(
        getNowPlayingMovies: mockGetNowPlayingMovies,
      );
      popularMovieBloc = PopularMovieListBloc(
        getPopularMovies: mockGetPopularMovies,
      );
      topRatedBloc = TopRatedMovieListBloc(
        getTopRatedMovies: mockGetTopRatedMovies,
      );
    },
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group(
    'Now playing movie test',
    () {
      blocTest<NowPlayingMovieListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetMovieList] event is added',
        build: () {
          when(
            mockGetNowPlayingMovies.execute(),
          ).thenAnswer(
            (_) async => Right(tMovieList),
          );
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: tMovieList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetNowPlayingMovies.execute(),
          );
        },
      );

      blocTest<NowPlayingMovieListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetMovieList] event is added',
        build: () {
          when(
            mockGetNowPlayingMovies.execute(),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occured'),
            ),
          );
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occured',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetNowPlayingMovies.execute(),
          );
        },
      );
    },
  );

  group(
    'Popular movie test',
    () {
      blocTest<PopularMovieListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetMovieList] event is added',
        build: () {
          when(
            mockGetPopularMovies.execute(),
          ).thenAnswer(
            (_) async => Right(tMovieList),
          );
          return popularMovieBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: tMovieList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetPopularMovies.execute(),
          );
        },
      );

      blocTest<PopularMovieListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetMovieList] event is added',
        build: () {
          when(
            mockGetPopularMovies.execute(),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occured'),
            ),
          );
          return popularMovieBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occured',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetPopularMovies.execute(),
          );
        },
      );
    },
  );

  group(
    'Top Rated movie test',
    () {
      blocTest<TopRatedMovieListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetMovieList] event is added',
        build: () {
          when(
            mockGetTopRatedMovies.execute(),
          ).thenAnswer(
            (_) async => Right(tMovieList),
          );
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: tMovieList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTopRatedMovies.execute(),
          );
        },
      );

      blocTest<TopRatedMovieListBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetMovieList] event is added',
        build: () {
          when(
            mockGetTopRatedMovies.execute(),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occured'),
            ),
          );
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(
          GetMovieListEvent(),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occured',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTopRatedMovies.execute(),
          );
        },
      );
    },
  );

  // group('popular movies', () {
  //   test('should change state to loading when usecase is called', () async {
  //     // arrange
  //     when(mockGetPopularMovies.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     // act
  //     provider.fetchPopularMovies();
  //     // assert
  //     expect(provider.popularMoviesState, RequestState.loading);
  //     // verify(provider.setState(RequestState.loading));
  //   });

  //   test('should change movies data when data is gotten successfully',
  //       () async {
  //     // arrange
  //     when(mockGetPopularMovies.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     // act
  //     await provider.fetchPopularMovies();
  //     // assert
  //     expect(provider.popularMoviesState, RequestState.loaded);
  //     expect(provider.popularMovies, tMovieList);
  //     expect(listenerCallCount, 2);
  //   });

  //   test('should return error when data is unsuccessful', () async {
  //     // arrange
  //     when(mockGetPopularMovies.execute())
  //         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //     // act
  //     await provider.fetchPopularMovies();
  //     // assert
  //     expect(provider.popularMoviesState, RequestState.error);
  //     expect(provider.message, 'Server Failure');
  //     expect(listenerCallCount, 2);
  //   });
  // });

  // group('top rated movies', () {
  //   test('should change state to loading when usecase is called', () async {
  //     // arrange
  //     when(mockGetTopRatedMovies.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     // act
  //     provider.fetchTopRatedMovies();
  //     // assert
  //     expect(provider.topRatedMoviesState, RequestState.loading);
  //   });

  //   test('should change movies data when data is gotten successfully',
  //       () async {
  //     // arrange
  //     when(mockGetTopRatedMovies.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     // act
  //     await provider.fetchTopRatedMovies();
  //     // assert
  //     expect(provider.topRatedMoviesState, RequestState.loaded);
  //     expect(provider.topRatedMovies, tMovieList);
  //     expect(listenerCallCount, 2);
  //   });

  //   test('should return error when data is unsuccessful', () async {
  //     // arrange
  //     when(mockGetTopRatedMovies.execute())
  //         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //     // act
  //     await provider.fetchTopRatedMovies();
  //     // assert
  //     expect(provider.topRatedMoviesState, RequestState.error);
  //     expect(provider.message, 'Server Failure');
  //     expect(listenerCallCount, 2);
  //   });
  // });
}
