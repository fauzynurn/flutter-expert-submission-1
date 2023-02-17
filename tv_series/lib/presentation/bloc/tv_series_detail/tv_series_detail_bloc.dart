import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_tv_series_detail.dart';
import 'events/tv_series_detail_event.dart';

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, GetAsyncDataState> {
  final GetTvSeriesDetail getTvSeriesDetail;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetTvSeriesDetailDataEvent>(
      ((event, emit) async {
        final id = event.id;
        emit(GetAsyncDataLoadingState());
        final result = await getTvSeriesDetail.execute(id);
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
