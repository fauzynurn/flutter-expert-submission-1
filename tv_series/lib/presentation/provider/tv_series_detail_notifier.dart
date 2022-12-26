import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/get_tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_recommendations.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
  });

  late TvSeriesDetail _tvSeries;
  TvSeriesDetail get tvSeries => _tvSeries;

  RequestState _tvSeriesState = RequestState.empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<TvSeries> _tvSeriesRecommendations = [];
  List<TvSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool isAddedToWatchlist = false;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesState = RequestState.loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvSeriesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _recommendationState = RequestState.loading;
        _tvSeries = tvSeries;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvSeriesRecommendation) {
            _recommendationState = RequestState.loaded;
            _tvSeriesRecommendations = tvSeriesRecommendation;
          },
        );
        _tvSeriesState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<String> addWatchlist(TvSeriesDetail tvSeriesDetail) async {
    debugPrint('override addWatchlist on the main app');
    return 'default_message';
  }

  Future<String> removeFromWatchlist(TvSeriesDetail tvSeriesDetail) async {
    debugPrint('override removeFromWatchlist on the main app');
    return 'default_message';
  }

  Future<void> loadWatchlistStatus(int id) async {
    debugPrint('override loadWatchlistStatus on the main app');
  }
}
