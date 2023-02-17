import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/utils.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/enum_state/enum_state_bloc.dart';
import 'package:core/presentation/bloc/enum_state/enum_state_event.dart';
import 'package:core/presentation/bloc/enum_state/enum_state_state.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:core/presentation/widgets/filter_type_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/common/constants.dart';

import '../bloc/events/get_watch_list_event.dart';
import '../bloc/movie/get_movie_watch_list_bloc.dart';
import '../bloc/tv_series/get_tv_series_watch_list_bloc.dart';

class WatchListPage extends StatefulWidget {
  static const routeName = '/watch-list';
  final VoidCallback onTapHamburgerButton;

  const WatchListPage({
    super.key,
    required this.onTapHamburgerButton,
  });

  @override
  WatchlistPageState createState() => WatchlistPageState();

  void onTapWatchListMovieItem(
    Movie movie, {
    required BuildContext context,
  }) {}

  void onTapWatchListTvSeriesItem(
    TvSeries tvSeries, {
    required BuildContext context,
  }) {}
}

class WatchlistPageState extends State<WatchListPage> with RouteAware {
  final EnumStateBloc<FilterType> watchListStateBloc =
      EnumStateBloc<FilterType>(
    FilterType.movies,
  );

  GetMovieWatchListBloc get getMovieWatchListBloc {
    return context.read<GetMovieWatchListBloc>();
  }

  GetTvSeriesWatchListBloc get getTvSeriesWatchListBloc {
    return context.read<GetTvSeriesWatchListBloc>();
  }

  @override
  void initState() {
    getMovieWatchListBloc.add(
      GetWatchListEvent(),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onTapHamburgerButton,
          icon: const Icon(
            Icons.menu,
          ),
        ),
        title: const Text('Watch List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => openFilter(
              context,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<EnumStateBloc<FilterType>, EnumStateSuccess>(
          listener: (context, state) {
            if (state.selectedState == FilterType.movies) {
              getMovieWatchListBloc.add(
                GetWatchListEvent(),
              );
            } else {
              getTvSeriesWatchListBloc.add(
                GetWatchListEvent(),
              );
            }
          },
          bloc: watchListStateBloc,
          builder: (context, state) {
            return state.selectedState == FilterType.movies
                ? movieWatchList(context)
                : tvSeriesWatchList(context);
          },
        ),
      ),
    );
  }

  Widget movieWatchList(BuildContext context) {
    return BlocBuilder<GetMovieWatchListBloc, GetAsyncDataState>(
      builder: (context, state) {
        if (state is GetAsyncDataLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetAsyncDataErrorState) {
          return Text(state.message);
        } else if (state is GetAsyncDataLoadedState<List<Movie>>) {
          final data = state.data;
          if (data.isNotEmpty) {
            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final movie = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      key: Key(
                        '$movieWatchListItemKey-${movie.id}',
                      ),
                      onTap: () {
                        widget.onTapWatchListMovieItem(
                          movie,
                          context: context,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: '$baseImageUrl${movie.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              ),
            );
          } else {
            return const Center(
              child: Text('No Data'),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget tvSeriesWatchList(BuildContext context) {
    return BlocBuilder<GetTvSeriesWatchListBloc, GetAsyncDataState>(
      builder: (context, state) {
        if (state is GetAsyncDataLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetAsyncDataErrorState) {
          return Text(state.message);
        } else if (state is GetAsyncDataLoadedState<List<TvSeries>>) {
          final data = state.data;
          if (data.isNotEmpty) {
            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final tvSeries = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      key: Key(
                        '$tvSeriesWatchListItemKey-${tvSeries.id}',
                      ),
                      onTap: () {
                        widget.onTapWatchListTvSeriesItem(
                          tvSeries,
                          context: context,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: '$baseImageUrl${tvSeries.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              ),
            );
          } else {
            return const Center(
              child: Text('No Data'),
            );
          }
        }
        return Container();
      },
    );
  }

  @override
  void didPopNext() {
    super.didPopNext();
    final currentFilterType = watchListStateBloc.state.selectedState;
    if (currentFilterType == FilterType.movies) {
      getMovieWatchListBloc.add(
        GetWatchListEvent(),
      );
    } else {
      getTvSeriesWatchListBloc.add(
        GetWatchListEvent(),
      );
    }
  }

  void openFilter(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (btmSheetContext) {
        return FilterTypePicker(
          onTapOption: (selectedType) {
            watchListStateBloc.add(
              SetEnumState(selectedType),
            );
            Navigator.pop(btmSheetContext);
          },
          selectedFilterType: watchListStateBloc.state.selectedState,
        );
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
