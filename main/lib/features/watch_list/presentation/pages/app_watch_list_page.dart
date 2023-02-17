import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:watch_list/presentation/pages/watch_list_page.dart';

class AppWatchListPage extends WatchListPage {
  AppWatchListPage({required super.onTapHamburgerButton});

  @override
  void onTapWatchListMovieItem(
    Movie movie, {
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      MovieDetailPage.routeName,
      arguments: movie.id,
    );
  }

  @override
  void onTapWatchListTvSeriesItem(
    TvSeries tvSeries, {
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      TvSeriesDetailPage.routeName,
      arguments: tvSeries.id,
    );
  }
}
