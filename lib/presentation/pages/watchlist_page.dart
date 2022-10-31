import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/filter_type.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:ditonton/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/filter_type_picker.dart';
import 'movie_detail_page.dart';
import 'tv_series_detail_page.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistNotifier>(context, listen: false).fetchResult());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist'), actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () => openFilter(
            context,
          ),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.Loaded) {
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
                              Navigator.pushNamed(
                                context,
                                MovieDetailPage.ROUTE_NAME,
                                arguments: movie.id,
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
                              Navigator.pushNamed(
                                context,
                                TvSeriesDetailPage.ROUTE_NAME,
                                arguments: tvSeries.id,
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
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }

  void openFilter(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<WatchlistNotifier>(
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
