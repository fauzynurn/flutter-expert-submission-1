import 'dart:io';

import 'package:core/data/data_sources/tv_series_remote_data_source.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:watch_list/data/data_sources/tv_series_local_data_source.dart';
import 'package:watch_list/data/models/tv_series_table.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries() async {
    try {
      final result = await remoteDataSource.getNowPlayingTvSeries();
      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure(),
      );
    } on TlsException {
      return Left(
        SSLFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure(),
      );
    } on TlsException {
      return Left(
        SSLFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
      int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesRecommendations(id);
      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure(),
      );
    } on TlsException {
      return Left(
        SSLFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async {
    try {
      final result = await remoteDataSource.getPopularTvSeries();
      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure(),
      );
    } on TlsException {
      return Left(
        SSLFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async {
    try {
      final result = await remoteDataSource.getTopRatedTvSeries();
      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure(),
      );
    } on TlsException {
      return Left(
        SSLFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    try {
      final result = await remoteDataSource.searchTvSeries(query);
      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure(),
      );
    } on TlsException {
      return Left(
        SSLFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource.insertWatchlist(
        TvSeriesTable.fromEntity(tvSeries),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource.removeWatchlist(
        TvSeriesTable.fromEntity(tvSeries),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    final result = await localDataSource.getWatchlistTvSeries();
    return Right(
      result.map((data) => data.toEntity()).toList(),
    );
  }
}
