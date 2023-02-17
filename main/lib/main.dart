import 'package:core/common/constants.dart';
import 'package:core/common/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/now_playing_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/popular_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/top_rated_movie_list_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:search/presentation/bloc/search_movie_bloc.dart';
import 'package:search/presentation/bloc/search_tv_series_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_recommendation_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/now_playing_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/popular_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/top_rated_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/pages/now_playing_tv_series_page.dart';
import 'package:tv_series/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:watch_list/presentation/bloc/get_watch_list_status_bloc.dart';

import 'package:watch_list/presentation/bloc/movie/add_movie_to_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/movie/get_movie_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/movie/remove_movie_from_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/add_tv_series_to_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/get_tv_series_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/remove_tv_series_from_watch_list_bloc.dart';
import 'features/movie_detail/presentation/pages/app_movie_detail_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/search/presentation/pages/app_search_page.dart';
import 'features/tv_series_detail/presentation/pages/app_tv_series_detail_page.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Movie
        BlocProvider<NowPlayingMovieListBloc>(
          create: (context) => di.locator<NowPlayingMovieListBloc>(),
        ),
        BlocProvider<TopRatedMovieListBloc>(
          create: (context) => di.locator<TopRatedMovieListBloc>(),
        ),
        BlocProvider<PopularMovieListBloc>(
          create: (context) => di.locator<PopularMovieListBloc>(),
        ),
        BlocProvider<MovieDetailBloc>(
          create: (context) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider<MovieRecommendationBloc>(
          create: (context) => di.locator<MovieRecommendationBloc>(),
        ),
        BlocProvider<GetWatchListStatusBloc>(
          create: (context) => di.locator<GetWatchListStatusBloc>(),
        ),
        BlocProvider<AddMovieToWatchListBloc>(
          create: (context) => di.locator<AddMovieToWatchListBloc>(),
        ),
        BlocProvider<RemoveMovieFromWatchListBloc>(
          create: (context) => di.locator<RemoveMovieFromWatchListBloc>(),
        ),

        /// Tv Series
        BlocProvider<NowPlayingTvSeriesListBloc>(
          create: (context) => di.locator<NowPlayingTvSeriesListBloc>(),
        ),
        BlocProvider<TopRatedTvSeriesListBloc>(
          create: (context) => di.locator<TopRatedTvSeriesListBloc>(),
        ),
        BlocProvider<PopularTvSeriesListBloc>(
          create: (context) => di.locator<PopularTvSeriesListBloc>(),
        ),
        BlocProvider<TvSeriesDetailBloc>(
          create: (context) => di.locator<TvSeriesDetailBloc>(),
        ),
        BlocProvider<TvSeriesRecommendationBloc>(
          create: (context) => di.locator<TvSeriesRecommendationBloc>(),
        ),
        BlocProvider<AddTvSeriesToWatchListBloc>(
          create: (context) => di.locator<AddTvSeriesToWatchListBloc>(),
        ),
        BlocProvider<RemoveTvSeriesFromWatchListBloc>(
          create: (context) => di.locator<RemoveTvSeriesFromWatchListBloc>(),
        ),

        /// Watch List
        BlocProvider<GetMovieWatchListBloc>(
          create: (context) => di.locator<GetMovieWatchListBloc>(),
        ),
        BlocProvider<GetTvSeriesWatchListBloc>(
          create: (context) => di.locator<GetTvSeriesWatchListBloc>(),
        ),

        /// Search
        BlocProvider<SearchMovieBloc>(
          create: (context) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider<SearchTvSeriesBloc>(
          create: (context) => di.locator<SearchTvSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Dicoding Flutter Submission',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => PopularMoviesPage(),
              );
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => TopRatedMoviesPage(),
              );
            case NowPlayingTvSeriesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingTvSeriesPage());
            case TopRatedTvSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => TopRatedTvSeriesPage(),
              );
            case PopularTvSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => PopularTvSeriesPage(),
              );
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => AppMovieDetailPage(id: id),
                settings: settings,
              );
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => AppTvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => AppSearchPage(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
