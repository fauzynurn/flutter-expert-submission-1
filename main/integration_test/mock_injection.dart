import 'package:core/data/data_sources/movie_remote_data_source.dart';
import 'package:core/data/data_sources/tv_series_remote_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:dio/dio.dart';
import 'package:ditonton/data/data_sources/db/database_helper.dart';
import 'package:ditonton/data/data_sources/network_client.dart';
import 'package:ditonton/data/data_sources/tv_series_remote_data_source_impl.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:movie/domain/use_cases/get_movie_detail.dart';
import 'package:movie/domain/use_cases/get_movie_recommendations.dart';
import 'package:movie/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie/domain/use_cases/get_popular_movies.dart';
import 'package:movie/domain/use_cases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/now_playing_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/popular_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/top_rated_movie_list_bloc.dart';
import 'package:search/domain/use_cases/search_movie.dart';
import 'package:search/domain/use_cases/search_tv_series.dart';
import 'package:search/presentation/bloc/search_movie_bloc.dart';
import 'package:search/presentation/bloc/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_recommendation_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/now_playing_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/popular_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/top_rated_tv_series_list_bloc.dart';
import 'package:watch_list/data/data_sources/movie_local_data_source.dart';
import 'package:watch_list/data/data_sources/tv_series_local_data_source.dart';
import 'package:watch_list/domain/use_cases/get_movie_watch_list.dart';
import 'package:watch_list/domain/use_cases/get_movie_watch_list_status.dart';
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list.dart';
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list_status.dart';
import 'package:watch_list/domain/use_cases/remove_movie_watch_list.dart';
import 'package:watch_list/domain/use_cases/remove_tv_series_watch_list.dart';
import 'package:watch_list/domain/use_cases/save_movie_watch_list.dart';
import 'package:watch_list/domain/use_cases/save_tv_series_watch_list.dart';
import 'package:watch_list/presentation/bloc/get_watch_list_status_bloc.dart';
import 'package:watch_list/presentation/bloc/movie/add_movie_to_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/movie/get_movie_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/movie/remove_movie_from_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/add_tv_series_to_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/get_tv_series_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/remove_tv_series_from_watch_list_bloc.dart';

import 'data/datasources/mock_movie_local_datasource_impl.dart';
import 'data/datasources/mock_movie_remote_datasource_impl.dart';
import 'data/datasources/mock_tv_series_local_datasource_impl.dart';

final locator = GetIt.instance;

void init() {
  /// Bloc
  locator.registerFactory(
    () => PopularMovieListBloc(
      getPopularMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMovieListBloc(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingMovieListBloc(
      getNowPlayingMovies: locator(),
    ),
  );

  locator.registerFactory<MovieDetailBloc>(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
    ),
  );

  locator.registerFactory(
    () => MovieRecommendationBloc(
      getMovieRecommendations: locator(),
    ),
  );

  locator.registerFactory<AddMovieToWatchListBloc>(
    () => AddMovieToWatchListBloc(
      saveMovieWatchList: locator(),
    ),
  );

  locator.registerFactory<RemoveMovieFromWatchListBloc>(
    () => RemoveMovieFromWatchListBloc(
      removeMovieWatchList: locator(),
    ),
  );

  locator.registerFactory<NowPlayingTvSeriesListBloc>(
    () => NowPlayingTvSeriesListBloc(
      getNowPlayingTvSeries: locator(),
    ),
  );

  locator.registerFactory<PopularTvSeriesListBloc>(
    () => PopularTvSeriesListBloc(
      getPopularTvSeries: locator(),
    ),
  );

  locator.registerFactory<TopRatedTvSeriesListBloc>(
    () => TopRatedTvSeriesListBloc(
      getTopRatedTvSeries: locator(),
    ),
  );

  locator.registerFactory<TvSeriesDetailBloc>(
    () => TvSeriesDetailBloc(
      getTvSeriesDetail: locator(),
    ),
  );

  locator.registerFactory(
    () => TvSeriesRecommendationBloc(
      getTvSeriesRecommendations: locator(),
    ),
  );

  locator.registerFactory<GetWatchListStatusBloc>(
    () => GetWatchListStatusBloc(
      getMovieWatchListStatus: locator(),
      getTvSeriesWatchListStatus: locator(),
    ),
  );

  locator.registerFactory<AddTvSeriesToWatchListBloc>(
    () => AddTvSeriesToWatchListBloc(
      saveTvSeriesWatchList: locator(),
    ),
  );

  locator.registerFactory<RemoveTvSeriesFromWatchListBloc>(
    () => RemoveTvSeriesFromWatchListBloc(
      removeTvSeriesWatchList: locator(),
    ),
  );

  locator.registerFactory<GetMovieWatchListBloc>(
    () => GetMovieWatchListBloc(
      getMovieWatchlist: locator(),
    ),
  );

  locator.registerFactory<GetTvSeriesWatchListBloc>(
    () => GetTvSeriesWatchListBloc(
      getTvSeriesWatchlist: locator(),
    ),
  );

  locator.registerFactory(
    () => SearchMovieBloc(
      searchMovie: locator(),
    ),
  );

  locator.registerFactory(
    () => SearchTvSeriesBloc(
      searchTvSeries: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SearchTvSeries(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvSeriesWatchListStatus(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveTvSeriesWatchList(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveTvSeriesWatchList(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvSeriesWatchList(
      locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetNowPlayingMovies(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetPopularMovies(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTopRatedMovies(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetMovieDetail(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetMovieRecommendations(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SearchMovie(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetMovieWatchListStatus(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveMovieWatchList(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveMovieWatchList(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetMovieWatchList(
      locator(),
    ),
  );

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MockMovieRemoteDatasourceImpl(),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MockMovieLocalDatasourceImpl(),
  );
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(
      client: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => MockTvSeriesLocalDatasourceImpl(),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(),
  );

  // external
  locator.registerLazySingletonAsync<Dio>(
    () => NetworkClient.dio,
  );
}
