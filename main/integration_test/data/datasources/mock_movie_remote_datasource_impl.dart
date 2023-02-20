import 'dart:convert';

import 'package:core/data/data_sources/movie_remote_data_source.dart';
import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/data/models/movie_model.dart';
import 'package:core/data/models/movie_response.dart';

import '../../../test/json_reader.dart';

class MockMovieRemoteDatasourceImpl extends MovieRemoteDataSource {
  Future<Map<String, dynamic>> getDataFromJson(String jsonPath) async {
    final jsonString = await readJson(jsonPath);
    return jsonDecode(
      jsonString,
    );
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    return MovieDetailResponse.fromJson(
      await getDataFromJson(
        'packages/core/assets/fixtures/movie_detail.json',
      ),
    );
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    return MovieResponse.fromJson(
      await getDataFromJson(
        'packages/core/assets/fixtures/movie_recommendations.json',
      ),
    ).movieList;
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    return MovieResponse.fromJson(
      await getDataFromJson(
        'packages/core/assets/fixtures/movie_now_playing.json',
      ),
    ).movieList;
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    return MovieResponse.fromJson(
      await getDataFromJson(
        'packages/core/assets/fixtures/movie_popular.json',
      ),
    ).movieList;
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    return MovieResponse.fromJson(
      await getDataFromJson(
        'packages/core/assets/fixtures/movie_top_rated.json',
      ),
    ).movieList;
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    return MovieResponse.fromJson(
      await getDataFromJson(
        'packages/core/assets/fixtures/search_spiderman_movie.json',
      ),
    ).movieList;
  }
}
