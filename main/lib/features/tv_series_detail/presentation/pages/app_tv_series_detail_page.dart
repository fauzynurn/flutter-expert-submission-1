import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:watch_list/presentation/bloc/events/add_content_to_watch_list_event.dart';
import 'package:watch_list/presentation/bloc/events/remove_content_from_watch_list_event.dart';
import 'package:watch_list/presentation/bloc/events/watch_list_status_event.dart';
import 'package:watch_list/presentation/bloc/get_watch_list_status_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/add_tv_series_to_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/remove_tv_series_from_watch_list_bloc.dart';

class AppTvSeriesDetailPage extends TvSeriesDetailPage {
  AppTvSeriesDetailPage({required super.id});

  @override
  void getTvSeriesWatchListStatus(
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
        type: FilterType.tvSeries,
      ),
    );
  }

  @override
  void addTvSeriesToWatchList(
    TvSeriesDetail movieDetail, {
    required BuildContext context,
  }) {
    BlocProvider.of<AddTvSeriesToWatchListBloc>(
      context,
    ).add(
      AddContentToWatchListEvent(
        content: movieDetail,
      ),
    );
    getTvSeriesWatchListStatus(
      movieDetail.id,
      context: context,
    );
  }

  @override
  void removeTvSeriesFromWatchList(
    TvSeriesDetail movieDetail, {
    required BuildContext context,
  }) {
    BlocProvider.of<RemoveTvSeriesFromWatchListBloc>(
      context,
    ).add(
      RemoveContentFromWatchListEvent(
        content: movieDetail,
      ),
    );
    getTvSeriesWatchListStatus(
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
        BlocListener<AddTvSeriesToWatchListBloc, GetAsyncDataState>(
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
        BlocListener<RemoveTvSeriesFromWatchListBloc, GetAsyncDataState>(
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
