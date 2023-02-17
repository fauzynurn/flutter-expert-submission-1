import 'package:collection/collection.dart';
import 'package:watch_list/data/data_sources/movie_local_data_source.dart';
import 'package:watch_list/data/models/movie_table.dart';

class MockMovieLocalDatasourceImpl extends MovieLocalDataSource {
  List<MovieTable> _movieWatchList = [];

  @override
  Future<MovieTable?> getMovieById(int id) {
    final movieTable = _movieWatchList.firstWhereOrNull(
      (element) => element.id == id,
    );
    return Future.value(
      movieTable,
    );
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies() {
    return Future.value(
      _movieWatchList,
    );
  }

  @override
  Future<String> insertWatchlist(MovieTable movie) {
    _movieWatchList.add(
      movie,
    );
    return Future.value(
      'success',
    );
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) {
    _movieWatchList.removeWhere(
      (element) => element.id == movie.id,
    );
    return Future.value(
      'success',
    );
  }
}
