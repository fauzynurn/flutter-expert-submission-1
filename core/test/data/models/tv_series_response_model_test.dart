import 'dart:convert';

import 'package:core/data/models/tv_series_model.dart';
import 'package:core/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../main/test/json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final tvSeriesModel = TvSeriesModel(
    backdropPath: "/sample.jpg",
    genreIds: [10763],
    id: 12345,
    originalName: "Tv Series Example",
    overview: "",
    popularity: 1499.942,
    posterPath: "/sample.jpg",
    firstAirDate: "2019-01-28",
    name: "Tv Series Example",
    voteAverage: 3.7,
    voteCount: 3,
  );
  final tvSeriesResponseModel = TvSeriesResponse(
    tvSeriesList: <TvSeriesModel>[tvSeriesModel],
  );
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        await readJson(
          'assets/fixtures/tv_series_now_playing.json',
        ),
      );
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(
        result,
        tvSeriesResponseModel,
      );
    });
  });

  group(
    'toJson',
    () {
      test(
        'should return a JSON map containing proper data',
        () async {
          // arrange

          // act
          final result = tvSeriesResponseModel.toJson();
          // assert
          final expectedJsonMap = {
            "results": [
              {
                "backdrop_path": "/sample.jpg",
                "genre_ids": [10763],
                "original_name": "Tv Series Example",
                "id": 12345,
                "overview": "",
                "popularity": 1499.942,
                "poster_path": "/sample.jpg",
                "first_air_date": "2019-01-28",
                "name": "Tv Series Example",
                "vote_average": 3.7,
                "vote_count": 3
              }
            ],
          };
          expect(
            result,
            expectedJsonMap,
          );
        },
      );
    },
  );
}
