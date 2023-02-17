import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/presentation/pages/tv_series_page.dart';

class AppHomeTvSeriesPage extends HomeTvSeriesPage {
  AppHomeTvSeriesPage({required super.onTapHamburgerButton});
  @override
  void onTapTvSeriesItem(
      TvSeries movie, {
        required BuildContext context,
      }) {
    Navigator.pushNamed(
      context,
      TvSeriesDetailPage.routeName,
      arguments: movie.id,
    );
  }

  @override
  void onTapPopularSeeMore({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      PopularTvSeriesPage.routeName,
    );
  }

  @override
  void onTapTopRatedSeeMore({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      TopRatedTvSeriesPage.routeName,
    );
  }

  @override
  void onTapSearchButton({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      SearchPage.routeName,
    );
  }
}
