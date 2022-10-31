import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final movieTable = MovieTable(
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
