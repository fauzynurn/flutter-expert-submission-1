import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    budget: 100,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: "https://google.com",
    id: 1,
    imdbId: 'imdb1',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    revenue: 12000,
    runtime: 120,
    status: 'Status',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    title: 'Title',
    voteAverage: 1.0,
    voteCount: 1,
    runtime: 120,
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
        readJson(
          'dummy_data/movie_detail.json',
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
        readJson(
          'dummy_data/movie_detail.json',
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
