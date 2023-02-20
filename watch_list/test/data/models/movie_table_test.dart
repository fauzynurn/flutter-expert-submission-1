import 'package:core/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_list/data/models/movie_table.dart';

import '../../../../main/test/dummy_data/dummy_objects.dart';

void main() {
  const movieTable = MovieTable(
    id: 1,
    type: 'movie',
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );
  final movieTableWatchList = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final movieTableMap = {
    'id': 1,
    'type': 'movie',
    'title': 'title',
    "posterPath": 'posterPath',
    'overview': 'overview',
  };
  test(
    'should return movie table from entity',
    () {
      final movieTableResult = MovieTable.fromEntity(
        testMovieDetail,
      );
      expect(
        movieTableResult,
        movieTable,
      );
    },
  );
  test(
    'should return movie table from map',
    () {
      final movieTableResult = MovieTable.fromMap(
        movieTableMap,
      );
      expect(
        movieTableResult,
        movieTable,
      );
    },
  );

  test(
    'should return json format from movie table',
    () {
      final movieTableJson = movieTable.toJson();
      expect(
        movieTableJson,
        movieTableMap,
      );
    },
  );

  test(
    'should return watch list format from movie table',
    () {
      final expectedMovieTableWatchList = movieTable.toEntity();
      expect(
        expectedMovieTableWatchList,
        movieTableWatchList,
      );
    },
  );
}
