import 'dart:convert';

import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../main/test/json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const tMovieResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/y5Z0WesTjvn59jP6yo459eUsbli.jpg',
    budget: 250000,
    genres: [
      GenreModel(
        id: 27,
        name: 'Horror',
      ),
      GenreModel(
        id: 53,
        name: 'Thriller',
      ),
    ],
    homepage: "http://www.terrifier2themovie.com/",
    id: 663712,
    imdbId: 'tt10403420',
    originalLanguage: 'en',
    originalTitle: 'Terrifier 2',
    overview:
        'After being resurrected by a sinister entity, Art the Clown returns to Miles County where he must hunt down and destroy a teenage girl and her younger brother on Halloween night.  As the body count rises, the siblings fight to stay alive while uncovering the true nature of Art\'s evil intent.',
    popularity: 6983.134,
    posterPath: '/yB8BMtvzHlMmRT1WmTQnGv1bcOK.jpg',
    releaseDate: '2022-10-06',
    revenue: 5325078,
    runtime: 138,
    status: 'Released',
    tagline: 'Who\'s Laughing Now?',
    title: 'Terrifier 2',
    video: false,
    voteAverage: 7.09,
    voteCount: 405,
  );

  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/y5Z0WesTjvn59jP6yo459eUsbli.jpg',
    genres: [
      Genre(
        id: 27,
        name: 'Horror',
      ),
      Genre(
        id: 53,
        name: 'Thriller',
      ),
    ],
    id: 663712,
    originalTitle: 'Terrifier 2',
    overview:
        'After being resurrected by a sinister entity, Art the Clown returns to Miles County where he must hunt down and destroy a teenage girl and her younger brother on Halloween night.  As the body count rises, the siblings fight to stay alive while uncovering the true nature of Art\'s evil intent.',
    posterPath: '/yB8BMtvzHlMmRT1WmTQnGv1bcOK.jpg',
    releaseDate: '2022-10-06',
    title: 'Terrifier 2',
    voteAverage: 7.09,
    voteCount: 405,
    runtime: 138,
  );

  test(
    'should be a subclass of movie entity',
    () async {
      final result = tMovieResponse.toEntity();
      expect(
        result,
        tMovieDetail,
      );
    },
  );

  test(
    'fromJson should return a subclass of movie detail ',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        await readJson(
          'assets/fixtures/movie_detail.json',
        ),
      );
      // act
      final result = MovieDetailResponse.fromJson(jsonMap);
      // assert
      expect(
        result,
        tMovieResponse,
      );
    },
  );

  test(
    'fromJson should return json from a movie detail ',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        await readJson(
          'assets/fixtures/movie_detail.json',
        ),
      );
      // act
      final result = tMovieResponse.toJson();
      // assert
      expect(
        result,
        jsonMap,
      );
    },
  );
}
