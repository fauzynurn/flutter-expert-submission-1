import 'package:core/domain/entities/filter_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list_status.dart';

import '../../domain/use_cases/get_movie_watch_list_status.dart';
import 'events/watch_list_status_event.dart';

class GetWatchListStatusBloc
    extends Bloc<WatchListStatusEvent, GetAsyncDataState> {
  final GetMovieWatchListStatus getMovieWatchListStatus;
  final GetTvSeriesWatchListStatus getTvSeriesWatchListStatus;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  GetWatchListStatusBloc({
    required this.getMovieWatchListStatus,
    required this.getTvSeriesWatchListStatus,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<WatchListStatusEvent>(
      ((event, emit) async {
        final id = event.id;
        final watchListType = event.type;
        emit(GetAsyncDataLoadingState());
        final result = await loadWatchlistStatus(
          id,
          watchListType,
        );
        emit(
          GetAsyncDataLoadedState<bool>(
            data: result,
          ),
        );
      }),
    );
  }

  Future<bool> loadWatchlistStatus(int id, FilterType type) async {
    if (type == FilterType.movies) {
      final result = await getMovieWatchListStatus.execute(id);
      return result;
    } else {
      final result = await getTvSeriesWatchListStatus.execute(id);
      return result;
    }
  }
}
