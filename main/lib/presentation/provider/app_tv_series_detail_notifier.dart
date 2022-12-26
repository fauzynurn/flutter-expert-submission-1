import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/provider/tv_series_detail_notifier.dart';
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list_status.dart';
import 'package:watch_list/domain/use_cases/save_tv_series_watch_list.dart';
import 'package:watch_list/domain/use_cases/remove_tv_series_watch_list.dart';

class AppTvSeriesDetailNotifier extends TvSeriesDetailNotifier {
  final GetTvSeriesWatchListStatus _getWatchListStatus;
  final SaveTvSeriesWatchList _saveWatchList;
  final RemoveTvSeriesWatchList _removeWatchList;

  AppTvSeriesDetailNotifier({
    required super.getTvSeriesDetail,
    required super.getTvSeriesRecommendations,
    required GetTvSeriesWatchListStatus getWatchListStatus,
    required SaveTvSeriesWatchList saveWatchList,
    required RemoveTvSeriesWatchList removeWatchList,
  }) : _getWatchListStatus = getWatchListStatus,
  _saveWatchList = saveWatchList,
  _removeWatchList = removeWatchList;

  @override
  Future<String> addWatchlist(TvSeriesDetail tvSeriesDetail) async {
    final result = await _saveWatchList.execute(tvSeriesDetail);

    final foldResult = await result.fold(
          (failure) async {
        return failure.message;
      },
          (successMessage) async {
        return successMessage;
      },
    );

    await loadWatchlistStatus(tvSeriesDetail.id);

    return foldResult;

  }

  @override
  Future<String> removeFromWatchlist(TvSeriesDetail tvSeriesDetail) async {
    final result = await _removeWatchList.execute(tvSeriesDetail);

    final foldResult = await result.fold(
          (failure) async {
        return failure.message;
      },
          (successMessage) async {
        return successMessage;
      },
    );

    await loadWatchlistStatus(tvSeriesDetail.id);

    return foldResult;
  }

  @override
  Future<void> loadWatchlistStatus(int id) async {
    final result = await _getWatchListStatus.execute(id);
    isAddedToWatchlist = result;
    notifyListeners();
  }
}
