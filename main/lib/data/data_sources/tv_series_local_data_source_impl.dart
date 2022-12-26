import 'package:core/common/exception.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:watch_list/data/data_sources/tv_series_local_data_source.dart';
import 'package:watch_list/data/models/tv_series_table.dart';

import 'db/database_helper.dart';

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.insertWatchlist(
        tvSeries: tvSeries,
      );
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.removeWatchlist(
        tvSeries: tvSeries,
      );
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getWatchItemById(id);
    if (result != null) {
      return TvSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getWatchlist(
      FilterType.tvSeries,
    );
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }
}
