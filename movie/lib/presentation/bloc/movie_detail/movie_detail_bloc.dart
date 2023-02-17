import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';

import '../../../domain/use_cases/get_movie_detail.dart';
import 'events/movie_detail_event.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, GetAsyncDataState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc({
    required this.getMovieDetail,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetMovieDetailDataEvent>(
      ((event, emit) async {
        final id = event.id;
        emit(GetAsyncDataLoadingState());
        final result = await getMovieDetail.execute(id);
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
