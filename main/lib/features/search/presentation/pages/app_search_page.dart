import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

class AppSearchPage extends SearchPage {
  @override
  void onTapMovieResult(
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
  void onTapTvSeriesResult(
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
