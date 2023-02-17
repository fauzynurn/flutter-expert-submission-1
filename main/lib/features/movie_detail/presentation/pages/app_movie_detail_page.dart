import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:watch_list/presentation/bloc/events/add_content_to_watch_list_event.dart';
import 'package:watch_list/presentation/bloc/events/remove_content_from_watch_list_event.dart';
import 'package:watch_list/presentation/bloc/events/watch_list_status_event.dart';
import 'package:watch_list/presentation/bloc/get_watch_list_status_bloc.dart';
import 'package:watch_list/presentation/bloc/movie/add_movie_to_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/movie/remove_movie_from_watch_list_bloc.dart';

class AppMovieDetailPage extends MovieDetailPage {
  AppMovieDetailPage({required super.id});

  @override
  void getMovieWatchListStatus(
    int id, {
    required BuildContext context,
    bool listen = false,
  }) {
    BlocProvider.of<GetWatchListStatusBloc>(
      context,
      listen: listen,
    ).add(
      WatchListStatusEvent(
        id: id,
        type: FilterType.movies,
      ),
    );
  }

  @override
  void addMovieToWatchList(
    MovieDetail movieDetail, {
    required BuildContext context,
  }) {
    BlocProvider.of<AddMovieToWatchListBloc>(
      context,
    ).add(
      AddContentToWatchListEvent(
        content: movieDetail,
      ),
    );
    getMovieWatchListStatus(
      movieDetail.id,
      context: context,
    );
  }

  @override
  void removeMovieFromWatchList(
    MovieDetail movieDetail, {
    required BuildContext context,
  }) {
    BlocProvider.of<RemoveMovieFromWatchListBloc>(
      context,
    ).add(
      RemoveContentFromWatchListEvent(
        content: movieDetail,
      ),
    );
    getMovieWatchListStatus(
      movieDetail.id,
      context: context,
    );
  }

  @override
  Widget watchListButton(
      Widget Function(BuildContext, GetAsyncDataState) builder) {
    return BlocBuilder<GetWatchListStatusBloc, GetAsyncDataState>(
      builder: (context, state) => builder(context, state),
    );
  }

  @override
  Widget parentWrapper(Widget child) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddMovieToWatchListBloc, GetAsyncDataState>(
          listener: (context, state) {
            if (state is GetAsyncDataLoadedState<String>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.data),
                ),
              );
            } else if (state is GetAsyncDataErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<RemoveMovieFromWatchListBloc, GetAsyncDataState>(
          listener: (context, state) {
            if (state is GetAsyncDataLoadedState<String>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.data),
                ),
              );
            } else if (state is GetAsyncDataErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
