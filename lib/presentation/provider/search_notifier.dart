import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/filter_type.dart';
import '../../domain/usecases/search_tv_series.dart';

class SearchNotifier extends ChangeNotifier {
  final SearchMovies searchMovies;
  final SearchTvSeries searchTvSeries;

  SearchNotifier({
    required this.searchMovies,
    required this.searchTvSeries,
  });

  RequestState _state = RequestState.Empty;
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
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _movieSearchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvSeriesSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _tvSeriesSearchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
