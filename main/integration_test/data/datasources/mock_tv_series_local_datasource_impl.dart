import 'package:watch_list/data/data_sources/tv_series_local_data_source.dart';
import 'package:watch_list/data/models/tv_series_table.dart';

class MockTvSeriesLocalDatasourceImpl extends TvSeriesLocalDataSource {
  List<TvSeriesTable> _tvSeriesWatchList = [];

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) {
    final tvSeriesTable = _tvSeriesWatchList.firstWhere(
      (element) => element.id == id,
    );
    return Future.value(
      tvSeriesTable,
    );
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() {
    return Future.value(
      _tvSeriesWatchList,
    );
  }

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) {
    _tvSeriesWatchList.add(
      tvSeries,
    );
    return Future.value(
      'success',
    );
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) {
    _tvSeriesWatchList.removeWhere(
      (element) => element.id == tvSeries.id,
    );
    return Future.value(
      'success',
    );
  }
}
