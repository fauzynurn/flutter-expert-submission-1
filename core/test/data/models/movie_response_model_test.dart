import 'dart:convert';

import 'package:core/data/models/movie_model.dart';
import 'package:core/data/models/movie_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../main/test/json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/y5Z0WesTjvn59jP6yo459eUsbli.jpg',
    genreIds: [
      27,
      53,
    ],
    id: 663712,
    originalTitle: 'Terrifier 2',
    overview:
        'After being resurrected by a sinister entity, Art the Clown returns to Miles County where he must hunt down and destroy a teenage girl and her younger brother on Halloween night.  As the body count rises, the siblings fight to stay alive while uncovering the true nature of Art\'s evil intent.',
    popularity: 6983.134,
    posterPath: '/yB8BMtvzHlMmRT1WmTQnGv1bcOK.jpg',
    releaseDate: '2022-10-06',
    title: 'Terrifier 2',
    video: false,
    voteAverage: 7.1,
    voteCount: 398,
  );
  const tMovieResponseModel = MovieResponse(
    movieList: <MovieModel>[
      tMovieModel,
    ],
  );
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        await readJson(
          'assets/fixtures/movie_now_playing.json',
        ),
      );
      // act
      final result = MovieResponse.fromJson(jsonMap);
      // assert
      expect(result, tMovieResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/y5Z0WesTjvn59jP6yo459eUsbli.jpg",
            "genre_ids": [27, 53],
            "id": 663712,
            "original_title": "Terrifier 2",
            "overview":
                "After being resurrected by a sinister entity, Art the Clown returns to Miles County where he must hunt down and destroy a teenage girl and her younger brother on Halloween night.  As the body count rises, the siblings fight to stay alive while uncovering the true nature of Art's evil intent.",
            "popularity": 6983.134,
            "poster_path": "/yB8BMtvzHlMmRT1WmTQnGv1bcOK.jpg",
            "release_date": "2022-10-06",
            "title": "Terrifier 2",
            "video": false,
            "vote_average": 7.1,
            "vote_count": 398
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
