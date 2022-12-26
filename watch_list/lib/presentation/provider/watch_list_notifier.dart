import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/foundation.dart';

import '../../domain/use_cases/get_movie_watch_list.dart';
import '../../domain/use_cases/get_tv_series_watch_list.dart';

class WatchListNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchListNotifier({
    required this.getMovieWatchlist,
    required this.getTvSeriesWatchlist,
  });

  final GetMovieWatchList getMovieWatchlist;
  final GetTvSeriesWatchList getTvSeriesWatchlist;

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
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getMovieWatchlist.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getTvSeriesWatchlist.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _watchlistState = RequestState.loaded;
        _watchlistTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
