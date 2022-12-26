import 'package:core/domain/entities/detail_list_type.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/detail_tv_series_list_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/presentation/pages/tv_series_page.dart';

class AppHomeTvSeriesPage extends HomeTvSeriesPage {
  AppHomeTvSeriesPage({
    required super.onTapHamburgerButton,
  });
  @override
  void onTapTvSeriesItem(
    TvSeries tvSeries, {
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      TvSeriesDetailPage.routeName,
      arguments: tvSeries.id,
    );
  }

  @override
  void onTapPopularSeeMore({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      DetailTvSeriesListPage.routeName,
      arguments: DetailListType.popular,
    );
  }

  @override
  void onTapTopRatedSeeMore({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      DetailTvSeriesListPage.routeName,
      arguments: DetailListType.topRated,
    );
  }

  @override
  void onTapNowPlayingSeeMore({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      DetailTvSeriesListPage.routeName,
      arguments: DetailListType.nowPlaying,
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
