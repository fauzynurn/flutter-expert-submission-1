import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_now_playing_tv_series.dart';
import 'events/get_tv_series_list_event.dart';

class NowPlayingTvSeriesListBloc
    extends Bloc<GetTvSeriesListEvent, GetAsyncDataState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  NowPlayingTvSeriesListBloc({
    required this.getNowPlayingTvSeries,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetTvSeriesListEvent>(
      ((event, emit) async {
        emit(GetAsyncDataLoadingState());
        final result = await getNowPlayingTvSeries.execute();
        result.fold(
          (failure) {
            emit(
              GetAsyncDataErrorState(
                message: failure.message,
              ),
            );
          },
          (data) {
            emit(
              GetAsyncDataLoadedState(
                data: data,
              ),
            );
          },
        );
      }),
    );
  }
}
