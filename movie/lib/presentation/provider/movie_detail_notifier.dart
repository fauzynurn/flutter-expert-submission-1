import 'package:core/common/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import '../../domain/use_cases/get_movie_detail.dart';
import '../../domain/use_cases/get_movie_recommendations.dart';

class MovieDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  });

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  RequestState _movieState = RequestState.empty;
  RequestState get movieState => _movieState;

  List<Movie> _movieRecommendations = [];
  List<Movie> get movieRecommendations => _movieRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool isAddedToWatchList = false;

  Future<void> fetchMovieDetail(int id) async {
    _movieState = RequestState.loading;
    notifyListeners();
    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _movieState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (movie) {
        _recommendationState = RequestState.loading;
        _movie = movie;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (movies) {
            _recommendationState = RequestState.loaded;
            _movieRecommendations = movies;
          },
        );
        _movieState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<String> addWatchlist(MovieDetail movie) async {
    debugPrint('override addWatchlist on the main app');
    return 'default_message';
  }

  Future<String> removeFromWatchlist(MovieDetail movie) async {
    debugPrint('override removeFromWatchlist on the main app');
    return 'default_message';
  }

  Future<void> loadWatchlistStatus(int id) async {
    debugPrint('override loadWatchlistStatus on the main app');
  }
}
