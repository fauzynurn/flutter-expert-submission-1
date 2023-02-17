import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/domain/use_cases/search_movie.dart';
import 'package:search/presentation/bloc/events/get_search_result_event.dart';
import 'package:search/presentation/bloc/events/reset_search_result_event.dart';

import 'events/search_result_event.dart';

class SearchMovieBloc extends Bloc<SearchResultEvent, GetAsyncDataState> {
  final SearchMovie searchMovie;

  SearchMovieBloc({
    required this.searchMovie,
  }) : super(
          GetAsyncDataInitialState(),
        ) {
    on<GetSearchResultEvent>(
      ((event, emit) async {
        final query = event.query;
        emit(GetAsyncDataLoadingState());
        final result = await searchMovie.execute(query);
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
    on<ResetSearchResultEvent>(
      (event, emit) {
        emit(
          GetAsyncDataLoadedState(
            data: const [],
          ),
        );
      },
    );
  }
}
