import 'package:core/common/state_enum.dart';
import 'package:core/common/utils.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:core/presentation/widgets/filter_type_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/watch_list_notifier.dart';

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
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => loadWatchList(),
    );
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
        title: const Text('Watchlist'),
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
        child: Consumer<WatchListNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.loaded) {
              if (data.selectedFilterType == FilterType.movies) {
                return data.watchlistMovies.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final movie = data.watchlistMovies[index];
                          return CardWithDescription(
                            title: movie.title ?? '',
                            overview: movie.overview ?? '',
                            posterPath: movie.posterPath ?? '',
                            onTap: () {
                              widget.onTapWatchListMovieItem(
                                movie,
                                context: context,
                              );
                            },
                          );
                        },
                        itemCount: data.watchlistMovies.length,
                      )
                    : const Center(
                        child: Text(
                          'No data found',
                        ),
                      );
              } else {
                return data.watchlistTvSeries.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final tvSeries = data.watchlistTvSeries[index];
                          return CardWithDescription(
                            title: tvSeries.name ?? '',
                            overview: tvSeries.overview ?? '',
                            posterPath: tvSeries.posterPath ?? '',
                            onTap: () {
                              widget.onTapWatchListTvSeriesItem(
                                tvSeries,
                                context: context,
                              );
                            },
                          );
                        },
                        itemCount: data.watchlistTvSeries.length,
                      )
                    : const Center(
                        child: Text(
                          'No data found',
                        ),
                      );
              }
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }

  void loadWatchList() {
    Provider.of<WatchListNotifier>(context, listen: false).fetchResult();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    loadWatchList();
  }

  void openFilter(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<WatchListNotifier>(
          builder: (bottomSheetContext, provider, child) {
            return FilterTypePicker(
              onTapOption: (selectedType) {
                provider.onChangeFilterType(selectedType);
                Navigator.pop(bottomSheetContext);
              },
              selectedFilterType: provider.selectedFilterType,
            );
          },
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
