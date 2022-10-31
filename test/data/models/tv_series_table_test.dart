import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tvSeriesTable = TvSeriesTable(
    id: 1,
    type: 'tv_series',
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );
  final tvSeriesTableWatchList = TvSeries.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tvSeriesTableMap = {
    'id': 1,
    'type': 'tv_series',
    'title': 'name',
    "posterPath": 'posterPath',
    'overview': 'overview',
  };
  test(
    'should return tv series table from entity',
    () {
      final tvSeriesTableResult = TvSeriesTable.fromEntity(
        testTvSeriesDetail,
      );
      expect(
        tvSeriesTableResult,
        tvSeriesTable,
      );
    },
  );
  test(
    'should return tv series table from map',
    () {
      final tvSeriesTableResult = TvSeriesTable.fromMap(
        tvSeriesTableMap,
      );
      expect(
        tvSeriesTableResult,
        tvSeriesTable,
      );
    },
  );

  test(
    'should return json format from tv series table',
    () {
      final expectedTvSeriesTableJson = tvSeriesTable.toJson();
      expect(
        expectedTvSeriesTableJson,
        tvSeriesTableMap,
      );
    },
  );

  test(
    'should return watch list format from tv series table',
    () {
      final expectedMovieTableWatchList = tvSeriesTable.toEntity();
      expect(
        expectedMovieTableWatchList,
        tvSeriesTableWatchList,
      );
    },
  );
}
