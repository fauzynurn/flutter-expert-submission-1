import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:core/data/models/tv_series_model.dart';
import 'package:core/data/models/tv_series_response.dart';
import 'package:dio/dio.dart';
import 'package:core/data/data_sources/tv_series_remote_data_source.dart';

import '../consts/app_data_consts.dart';

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  final Dio client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    final response = await client.get(
      'tv/airing_today?$apiKey',
    );

    return TvSeriesResponse.fromJson(
      response.data,
    ).tvSeriesList;
  }

  @override
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    final response = await client.get(
      'tv/$id?$apiKey',
    );

    return TvSeriesDetailModel.fromJson(
      response.data,
    );
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    final response = await client.get(
      'tv/$id/recommendations?$apiKey',
    );

    return TvSeriesResponse.fromJson(
      response.data,
    ).tvSeriesList;
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response = await client.get(
      'tv/popular?$apiKey',
    );

    return TvSeriesResponse.fromJson(
      response.data,
    ).tvSeriesList;
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response = await client.get(
      'tv/top_rated?$apiKey',
    );

    return TvSeriesResponse.fromJson(
      response.data,
    ).tvSeriesList;
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client.get(
      'search/tv?$apiKey&query=$query',
    );

    return TvSeriesResponse.fromJson(
      response.data,
    ).tvSeriesList;
  }
}
