import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/movie_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:search/presentation/pages/search_page.dart';

class AppHomeMoviePage extends HomeMoviePage {
  AppHomeMoviePage({required super.onTapHamburgerButton});
  @override
  void onTapMovieItem(
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
  void onTapPopularSeeMore({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      PopularMoviesPage.routeName,
    );
  }

  @override
  void onTapTopRatedSeeMore({
    required BuildContext context,
  }) {
    Navigator.pushNamed(
      context,
      TopRatedMoviesPage.routeName,
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
