import 'dart:convert';

import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/data/models/movie_response.dart';
import 'package:dio/dio.dart';
import 'package:ditonton/data/consts/app_data_consts.dart';
import 'package:ditonton/data/data_sources/movie_remote_data_source_impl.dart';
import 'package:ditonton/data/data_sources/network_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MovieRemoteDataSourceImpl dataSource;
  late DioAdapter dioAdapter;

  setUp(
    () async {
      final dio = await NetworkClient.dio;
      dioAdapter = DioAdapter(dio: dio);
      dataSource = MovieRemoteDataSourceImpl(
        client: dio,
      );
    },
  );

  group('get Now Playing Movies', () {
    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        final tMovieList = MovieResponse.fromJson(
          json.decode(
            await readJson(
              'packages/core/assets/fixtures/movie_now_playing.json',
            ),
          ),
        ).movieList;
        final tMovieListJsonFormat = json.decode(
          await readJson(
              'packages/core/assets/fixtures/movie_now_playing.json'),
        );

        dioAdapter.onGet(
          'movie/now_playing?$apiKey',
          (server) => server.reply(
            200,
            tMovieListJsonFormat,
          ),
        );
        // act
        final result = await dataSource.getNowPlayingMovies();
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'movie/now_playing?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.getNowPlayingMovies();
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get Popular Movies', () {
    test('should return list of movies when response is success (200)',
        () async {
      // arrange
      final tMovieList = MovieResponse.fromJson(
        json.decode(
          await readJson(
            'packages/core/assets/fixtures/movie_popular.json',
          ),
        ),
      ).movieList;
      final tMovieListJsonFormat = json.decode(
        await readJson(
          'packages/core/assets/fixtures/movie_popular.json',
        ),
      );

      dioAdapter.onGet(
        'movie/popular?$apiKey',
        (server) => server.reply(
          200,
          tMovieListJsonFormat,
        ),
      );

      // act
      final result = await dataSource.getPopularMovies();
      // assert
      expect(result, tMovieList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'movie/popular?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );

      // act
      final call = dataSource.getPopularMovies();
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get Top Rated Movies', () {
    test('should return list of movies when response code is 200 ', () async {
      // arrange
      final tMovieList = MovieResponse.fromJson(
        json.decode(
          await readJson(
            'packages/core/assets/fixtures/movie_top_rated.json',
          ),
        ),
      ).movieList;
      final tMovieListJsonResponse = json.decode(
        await readJson(
          'packages/core/assets/fixtures/movie_top_rated.json',
        ),
      );

      dioAdapter.onGet(
        'movie/top_rated?$apiKey',
        (server) => server.reply(
          200,
          tMovieListJsonResponse,
        ),
      );
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result, tMovieList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      /// arrange
      dioAdapter.onGet(
        'movie/top_rated?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );

      // act
      final call = dataSource.getTopRatedMovies();
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get movie detail', () {
    final tId = 1;

    test('should return movie detail when the response code is 200', () async {
      // arrange
      final tMovieDetail = MovieDetailResponse.fromJson(
        json.decode(
          await readJson('packages/core/assets/fixtures/movie_detail.json'),
        ),
      );
      final tMovieDetailJsonFormat = json.decode(
        await readJson('packages/core/assets/fixtures/movie_detail.json'),
      );

      dioAdapter.onGet(
        'movie/$tId?$apiKey',
        (server) => server.reply(
          200,
          tMovieDetailJsonFormat,
        ),
      );

      // act
      final result = await dataSource.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'movie/$tId?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );

      // act
      final call = dataSource.getMovieDetail(tId);
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get movie recommendations', () {
    final tId = 1;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      final tMovieList = MovieResponse.fromJson(
        json.decode(
          await readJson(
            'packages/core/assets/fixtures/movie_recommendations.json',
          ),
        ),
      ).movieList;

      final tMovieListJsonFormat = json.decode(
        await readJson(
          'packages/core/assets/fixtures/movie_recommendations.json',
        ),
      );

      dioAdapter.onGet(
        'movie/$tId/recommendations?$apiKey',
        (server) => server.reply(
          200,
          tMovieListJsonFormat,
        ),
      );

      // act
      final result = await dataSource.getMovieRecommendations(tId);
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'movie/$tId/recommendations?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.getMovieRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('search movies', () {
    final tQuery = 'Spiderman';

    test('should return list of movies when response code is 200', () async {
      // arrange
      final tSearchResult = MovieResponse.fromJson(
        json.decode(
          await readJson(
            'packages/core/assets/fixtures/search_spiderman_movie.json',
          ),
        ),
      ).movieList;

      final tSearchResultJsonFormat = json.decode(
        await readJson(
          'packages/core/assets/fixtures/search_spiderman_movie.json',
        ),
      );
      dioAdapter.onGet(
        'search/movie?$apiKey&query=$tQuery',
        (server) => server.reply(
          200,
          tSearchResultJsonFormat,
        ),
      );
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      dioAdapter.onGet(
        'search/movie?$apiKey&query=$tQuery',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.searchMovies(tQuery);
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });
}
