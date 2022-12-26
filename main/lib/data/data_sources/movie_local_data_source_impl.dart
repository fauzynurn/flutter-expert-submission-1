import 'package:core/common/exception.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:watch_list/data/data_sources/movie_local_data_source.dart';
import 'package:watch_list/data/models/movie_table.dart';

import 'db/database_helper.dart';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelper databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      await databaseHelper.insertWatchlist(
        movie: movie,
      );
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    try {
      await databaseHelper.removeWatchlist(
        movie: movie,
      );
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final result = await databaseHelper.getWatchItemById(id);
    if (result != null) {
      return MovieTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies() async {
    final result = await databaseHelper.getWatchlist(
      FilterType.movies,
    );
    return result
        .map(
          (data) => MovieTable.fromMap(data),
        )
        .toList();
  }
}
