import 'dart:convert';

import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/domain/entities/genre.dart';

import '../../json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final tvSeriesDetailModel = TvSeriesDetailModel(
      backdropPath: 'backdropPath',
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      homepage: 'homepage',
      popularity: 1,
      imdbId: 'imdbId',
      originalLanguage: 'originalLanguage',
      status: 'live',
      tagline: 'horror',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: 'name',
      voteAverage: 1,
      voteCount: 1,
      runtimes: [
        60
      ],
      genres: [
        GenreModel(
          id: 1,
          name: 'genre-1',
        ),
      ]);

  final tvSeriesDetail = TvSeriesDetail(
    backdropPath: 'backdropPath',
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    runtimes: [60],
    genres: [
      Genre(id: 1, name: 'genre-1'),
    ],
  );

  test(
    'should be a subclass of Tv Series entity',
    () async {
      final result = tvSeriesDetailModel.toEntity();
      expect(
        result,
        tvSeriesDetail,
      );
    },
  );

  test(
    'fromJson should return a subclass of Tv Series detail ',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        await readJson(
          'assets/fixtures/tv_series_detail.json',
        ),
      );
      // act
      final result = TvSeriesDetailModel.fromJson(jsonMap);
      // assert
      expect(
        result,
        tvSeriesDetailModel,
      );
    },
  );

  test(
    'toJson should return a json from Tv Series detail ',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        await readJson(
          'assets/fixtures/tv_series_detail.json',
        ),
      );
      // act
      final result = tvSeriesDetailModel.toJson();
      // assert
      expect(
        result,
        jsonMap,
      );
    },
  );
}
