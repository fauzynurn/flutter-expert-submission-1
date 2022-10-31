import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/filter_type.dart';
import '../../domain/usecases/get_watchlist_tv_series.dart';

class WatchlistNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier({
    required this.getWatchlistMovies,
    required this.getWatchlistTvSeries,
  });

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTvSeries getWatchlistTvSeries;

  FilterType _selectedFilterType = FilterType.movies;
  FilterType get selectedFilterType => _selectedFilterType;

  void onChangeFilterType(FilterType? type) {
    if (type != null) {
      _selectedFilterType = type;
      fetchResult();
      notifyListeners();
    }
  }

  Future<void> fetchResult() async {
    if (selectedFilterType == FilterType.movies) {
      await fetchWatchlistMovie();
    } else {
      await fetchWatchlistTvSeries();
    }
  }

  Future<void> fetchWatchlistMovie() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
