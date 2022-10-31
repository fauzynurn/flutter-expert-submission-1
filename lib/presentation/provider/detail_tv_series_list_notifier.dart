import 'package:dartz/dartz.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/detail_list_type.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/foundation.dart';

import '../../common/failure.dart';
import '../../domain/usecases/get_popular_tv_series.dart';

class DetailTvSeriesListNotifier extends ChangeNotifier {
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  DetailTvSeriesListNotifier({
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
    required this.getNowPlayingTvSeries,
  });

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvSeries> _tvSeries = [];
  List<TvSeries> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSeries({
    required DetailListType detailListType,
  }) async {
    _state = RequestState.Loading;
    notifyListeners();

    late Either<Failure, List<TvSeries>> result;
    switch (detailListType) {
      case DetailListType.popular:
        result = await getPopularTvSeries.execute();
        break;
      case DetailListType.nowPlaying:
        result = await getNowPlayingTvSeries.execute();
        break;
      case DetailListType.topRated:
        result = await getTopRatedTvSeries.execute();
        break;
    }

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSeries = tvSeriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
