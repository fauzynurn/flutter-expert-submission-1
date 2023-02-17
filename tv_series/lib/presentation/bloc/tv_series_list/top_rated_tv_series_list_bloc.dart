import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_top_rated_tv_series.dart';
import 'events/get_tv_series_list_event.dart';

class TopRatedTvSeriesListBloc
    extends Bloc<GetTvSeriesListEvent, GetAsyncDataState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesListBloc({
    required this.getTopRatedTvSeries,
  }) : super(
    GetAsyncDataInitialState(),
  ) {
    on<GetTvSeriesListEvent>(
      ((event, emit) async {
        emit(GetAsyncDataLoadingState());
        final result = await getTopRatedTvSeries.execute();
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
