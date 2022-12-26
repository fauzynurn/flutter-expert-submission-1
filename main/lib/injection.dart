import 'package:core/data/data_sources/movie_remote_data_source.dart';
import 'package:core/data/data_sources/tv_series_remote_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/data/network_client.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/presentation/provider/app_movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/app_tv_series_detail_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movie/domain/use_cases/get_movie_detail.dart';
import 'package:movie/domain/use_cases/get_movie_recommendations.dart';
import 'package:movie/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie/domain/use_cases/get_popular_movies.dart';
import 'package:movie/domain/use_cases/get_top_rated_movies.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:search/domain/use_cases/search_movie.dart';
import 'package:search/domain/use_cases/search_tv_series.dart';
import 'package:search/presentation/provider/search_notifier.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/presentation/provider/tv_series_detail_notifier.dart';
import 'package:tv_series/presentation/provider/tv_series_list_notifier.dart';
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
import 'package:watch_list/presentation/provider/watch_list_notifier.dart';
import 'package:tv_series/presentation/provider/detail_tv_series_list_notifier.dart';

import 'data/data_sources/db/database_helper.dart';
import 'data/data_sources/movie_local_data_source_impl.dart';
import 'data/data_sources/movie_remote_data_source_impl.dart';
import 'data/data_sources/tv_series_local_data_source_impl.dart';
import 'data/data_sources/tv_series_remote_data_source_impl.dart';
import 'data/repositories/tv_series_repository_impl.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory<MovieDetailNotifier>(
    () => AppMovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchList: locator(),
      removeWatchList: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchListNotifier(
      getMovieWatchlist: locator(),
      getTvSeriesWatchlist: locator(),
    ),
  );

  locator.registerFactory<TvSeriesDetailNotifier>(
    () => AppTvSeriesDetailNotifier(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchList: locator(),
      removeWatchList: locator(),
    ),
  );

  locator.registerFactory(
    () => SearchNotifier(
      searchMovie: locator(),
      searchTvSeries: locator(),
    ),
  );

  locator.registerFactory(
    () => TvSeriesListNotifier(
      getNowPlayingTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );

  locator.registerFactory(
    () => DetailTvSeriesListNotifier(
      getPopularTvSeries: locator(),
      getNowPlayingTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  // use case
  locator.registerLazySingleton<GetNowPlayingTvSeries>(
    () => GetNowPlayingTvSeries(
      locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetPopularTvSeries(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTopRatedTvSeries(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvSeriesDetail(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvSeriesRecommendations(
      locator(),
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
    () => MovieRemoteDataSourceImpl(
      client: locator(),
    ),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(
      databaseHelper: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(
      client: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => TvSeriesLocalDataSourceImpl(
      databaseHelper: locator(),
    ),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(),
  );

  // external
  locator.registerLazySingleton<http.Client>(
    () => NetworkClient(),
  );
}
