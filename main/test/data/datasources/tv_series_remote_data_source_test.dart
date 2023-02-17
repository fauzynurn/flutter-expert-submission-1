import 'dart:convert';

import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:core/data/models/tv_series_response.dart';
import 'package:dio/dio.dart';
import 'package:ditonton/data/consts/app_data_consts.dart';
import 'package:ditonton/data/data_sources/network_client.dart';
import 'package:ditonton/data/data_sources/tv_series_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TvSeriesRemoteDataSourceImpl dataSource;
  late DioAdapter dioAdapter;

  setUp(() async {
    final dio = await NetworkClient.dio;
    dioAdapter = DioAdapter(dio: dio);
    dataSource = TvSeriesRemoteDataSourceImpl(
      client: dio,
    );
  });

  group('get Now Playing Tv Series', () {
    test('should return list of Tv Series Model when the response code is 200',
        () async {
      // arrange
      final tTvSeriesList = TvSeriesResponse.fromJson(
        json.decode(
          await readJson(
            'assets/fixtures/tv_series_now_playing.json',
          ),
        ),
      ).tvSeriesList;
      final tTvSeriesListJsonFormat = json.decode(
        await readJson('assets/fixtures/tv_series_now_playing.json'),
      );
      dioAdapter.onGet(
        'tv/airing_today?$apiKey',
        (server) => server.reply(
          200,
          tTvSeriesListJsonFormat,
        ),
      );
      // act
      final result = await dataSource.getNowPlayingTvSeries();
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw a DioError when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'tv/airing_today?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.getNowPlayingTvSeries();
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get Popular Tv Series', () {
    test('should return list of Tv Series when response is success (200)',
        () async {
      // arrange
      final tTvSeriesList = TvSeriesResponse.fromJson(
        json.decode(
          await readJson('assets/fixtures/tv_series_popular.json'),
        ),
      ).tvSeriesList;
      final tTvSeriesListJsonFormat = json.decode(
        await readJson('assets/fixtures/tv_series_popular.json'),
      );
      dioAdapter.onGet(
        'tv/popular?$apiKey',
        (server) => server.reply(
          200,
          tTvSeriesListJsonFormat,
        ),
      );
      // act
      final result = await dataSource.getPopularTvSeries();
      // assert
      expect(result, tTvSeriesList);
    });

    test('should throw a DioError when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'tv/airing_today?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.getPopularTvSeries();
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get Top Rated Tv Series', () {
    test('should return list of TvSeries when response code is 200 ', () async {
      // arrange
      final tTvSeriesList = TvSeriesResponse.fromJson(
        json.decode(
          await readJson('assets/fixtures/tv_series_top_rated.json'),
        ),
      ).tvSeriesList;
      final tTvSeriesListJsonFormat = json.decode(
        await readJson('assets/fixtures/tv_series_top_rated.json'),
      );
      dioAdapter.onGet(
        'tv/top_rated?$apiKey',
        (server) => server.reply(
          200,
          tTvSeriesListJsonFormat,
        ),
      );
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, tTvSeriesList);
    });

    test('should throw DioError when response code is other than 200',
        () async {
      // arrange
      dioAdapter.onGet(
        'tv/top_rated?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.getTopRatedTvSeries();
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get tv series detail', () {
    final tId = 1;

    test('should return tv series detail when the response code is 200',
        () async {
      // arrange
      final tTvSeriesDetail = TvSeriesDetailModel.fromJson(
        json.decode(
          await readJson(
            'assets/fixtures/tv_series_detail.json',
          ),
        ),
      );
      final tTvSeriesDetailJsonFormat = json.decode(
        await readJson('assets/fixtures/tv_series_detail.json'),
      );

      dioAdapter.onGet(
        'tv/$tId?$apiKey',
        (server) => server.reply(
          200,
          tTvSeriesDetailJsonFormat,
        ),
      );
      // act
      final result = await dataSource.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tTvSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'tv/$tId?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.getTvSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group('get tv series recommendations', () {
    final tId = 1;

    test('should return list of tv series model when the response code is 200',
        () async {
      // arrange
      final tTvSeriesList = TvSeriesResponse.fromJson(
        json.decode(
          await readJson('assets/fixtures/tv_series_recommendations.json'),
        ),
      ).tvSeriesList;
      final tTvSeriesListJsonFormat = json.decode(
        await readJson('assets/fixtures/tv_series_recommendations.json'),
      );
      dioAdapter.onGet(
        'tv/$tId/recommendations?$apiKey',
        (server) => server.reply(
          200,
          tTvSeriesListJsonFormat,
        ),
      );
      // act
      final result = await dataSource.getTvSeriesRecommendations(tId);
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        'tv/$tId/recommendations?$apiKey',
        (server) => server.throws(
          404,
          DioError.connectionError(
            requestOptions: RequestOptions(),
            reason: 'error',
          ),
        ),
      );
      // act
      final call = dataSource.getTvSeriesRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<DioError>()));
    });
  });

  group(
    'search Tv Series',
    () {
      final tQuery = 'house';

      test('should return list of TvSeries when response code is 200',
          () async {
        // arrange
        final tSearchResult = TvSeriesResponse.fromJson(
          json.decode(
            await readJson('assets/fixtures/search_house_tv_series.json'),
          ),
        ).tvSeriesList;
        final tSearchResultJsonFormat = json.decode(
          await readJson('assets/fixtures/search_house_tv_series.json'),
        );
        dioAdapter.onGet(
          'search/tv?$apiKey&query=$tQuery',
          (server) => server.reply(
            200,
            tSearchResultJsonFormat,
          ),
        );

        // act
        final result = await dataSource.searchTvSeries(tQuery);
        // assert
        expect(result, tSearchResult);
      });

      test(
        'should throw DioError when response code is other than 200',
        () async {
          // arrange
          dioAdapter.onGet(
            'search/tv?$apiKey&query=$tQuery',
            (server) => server.throws(
              404,
              DioError.connectionError(
                requestOptions: RequestOptions(),
                reason: 'error',
              ),
            ),
          );
          // act
          final call = dataSource.searchTvSeries(tQuery);
          // assert
          expect(
            () => call,
            throwsA(
              isA<DioError>(),
            ),
          );
        },
      );
    },
  );
}
