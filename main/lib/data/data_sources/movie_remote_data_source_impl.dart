import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/data/models/movie_model.dart';
import 'package:core/data/data_sources/movie_remote_data_source.dart';
import 'package:core/data/models/movie_response.dart';
import 'package:dio/dio.dart';

import '../consts/app_data_consts.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get('movie/now_playing?$apiKey');

    return MovieResponse.fromJson(
      response.data,
    ).movieList;
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client.get('movie/$id?$apiKey');

    return MovieDetailResponse.fromJson(
      response.data,
    );
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get('movie/$id/recommendations?$apiKey');

    return MovieResponse.fromJson(
      response.data,
    ).movieList;
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await client.get('movie/popular?$apiKey');

    return MovieResponse.fromJson(
      response.data,
    ).movieList;
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await client.get('movie/top_rated?$apiKey');

    return MovieResponse.fromJson(
      response.data,
    ).movieList;
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get('search/movie?$apiKey&query=$query');

    return MovieResponse.fromJson(
      response.data,
    ).movieList;
  }
}
