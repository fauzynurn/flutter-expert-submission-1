import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';

import '../../domain/use_cases/search_movie.dart';
import '../../domain/use_cases/search_tv_series.dart';

class SearchNotifier extends ChangeNotifier {
  final SearchMovie searchMovie;
  final SearchTvSeries searchTvSeries;

  SearchNotifier({
    required this.searchMovie,
    required this.searchTvSeries,
  });

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TvSeries> _tvSeriesSearchResult = [];
  List<Movie> _movieSearchResult = [];

  List<dynamic> get searchResult {
    return _selectedFilterType == FilterType.movies
        ? _movieSearchResult
        : _tvSeriesSearchResult;
  }

  String _message = '';
  String get message => _message;

  FilterType _selectedFilterType = FilterType.movies;
  FilterType get selectedFilterType => _selectedFilterType;

  void onChangeFilterType(FilterType? type) {
    if (type != null) {
      _selectedFilterType = type;

      /// reset saved another search result
      type == FilterType.movies
          ? _tvSeriesSearchResult = []
          : _movieSearchResult = [];
      notifyListeners();
    }
  }

  Future<void> fetchResult(String query) async {
    if (selectedFilterType == FilterType.movies) {
      await fetchMovieSearch(
        query,
      );
    } else {
      await fetchTvSeriesSearch(
        query,
      );
    }
  }

  Future<void> fetchMovieSearch(String query) async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await searchMovie.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (data) {
        _movieSearchResult = data;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvSeriesSearch(String query) async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (data) {
        _tvSeriesSearchResult = data;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
