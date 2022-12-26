import 'package:core/domain/entities/movie_detail.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:watch_list/domain/use_cases/get_movie_watch_list_status.dart';
import 'package:watch_list/domain/use_cases/save_movie_watch_list.dart';
import 'package:watch_list/domain/use_cases/remove_movie_watch_list.dart';

class AppMovieDetailNotifier extends MovieDetailNotifier {
  final GetMovieWatchListStatus _getWatchListStatus;
  final SaveMovieWatchList _saveWatchList;
  final RemoveMovieWatchList _removeWatchList;

  AppMovieDetailNotifier({
    required super.getMovieDetail,
    required super.getMovieRecommendations,
    required GetMovieWatchListStatus getWatchListStatus,
    required SaveMovieWatchList saveWatchList,
    required RemoveMovieWatchList removeWatchList,
  }) : _getWatchListStatus = getWatchListStatus,
  _saveWatchList = saveWatchList,
  _removeWatchList = removeWatchList;

  @override
  Future<String> addWatchlist(MovieDetail movie) async {
    final result = await _saveWatchList.execute(movie);

    final foldResult = await result.fold(
          (failure) async {
        return failure.message;
      },
          (successMessage) async {
        return successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);

    return foldResult;

  }

  @override
  Future<String> removeFromWatchlist(MovieDetail movie) async {
    final result = await _removeWatchList.execute(movie);

    final foldResult = await result.fold(
          (failure) async {
        return failure.message;
      },
          (successMessage) async {
        return successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);

    return foldResult;
  }

  @override
  Future<void> loadWatchlistStatus(int id) async {
    final result = await _getWatchListStatus.execute(id);
    isAddedToWatchList = result;
    notifyListeners();
  }
}
