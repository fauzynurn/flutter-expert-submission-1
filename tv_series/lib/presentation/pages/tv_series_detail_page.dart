import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../common/constants.dart';
import '../bloc/tv_series_detail/events/tv_series_detail_event.dart';
import '../bloc/tv_series_detail/tv_series_detail_bloc.dart';
import '../bloc/tv_series_detail/tv_series_recommendation_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = '/tv-series/detail';

  final int id;
  const TvSeriesDetailPage({
    super.key,
    required this.id,
  });

  void getTvSeriesWatchListStatus(
      int id, {
        required BuildContext context,
        bool listen = true,
      }) {}

  void addTvSeriesToWatchList(
      TvSeriesDetail tvSeriesDetail, {
        required BuildContext context,
      }) async {}

  void removeTvSeriesFromWatchList(
      TvSeriesDetail tvSeriesDetail, {
        required BuildContext context,
      }) async {}

  Widget watchListButton(
      Widget Function(BuildContext, GetAsyncDataState) builder,
      ) {
    return const SizedBox();
  }

  Widget parentWrapper(Widget child) {
    return child;
  }

  @override
  TvSeriesDetailPageState createState() => TvSeriesDetailPageState();
}

class TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    context.read<TvSeriesDetailBloc>().add(
      GetTvSeriesDetailDataEvent(
        id: widget.id,
      ),
    );
    context.read<TvSeriesRecommendationBloc>().add(
      GetRecommendationTvSeriesDataEvent(
        id: widget.id,
      ),
    );
    widget.getTvSeriesWatchListStatus(
      widget.id,
      context: context,
      listen: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key(
        tvSeriesDetailScaffoldKey,
      ),
      body: widget.parentWrapper(
        BlocBuilder<TvSeriesDetailBloc, GetAsyncDataState>(
          builder: (context, state) {
            if (state is GetAsyncDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetAsyncDataLoadedState<TvSeriesDetail>) {
              return SafeArea(
                child: DetailContent(
                  state.data,
                  onAddTvSeriesToWatchList: (tvSeriesDetail) {
                    return widget.addTvSeriesToWatchList(
                      tvSeriesDetail,
                      context: context,
                    );
                  },
                  onRemoveTvSeriesFromWatchList: (tvSeriesDetail) {
                    return widget.removeTvSeriesFromWatchList(
                      tvSeriesDetail,
                      context: context,
                    );
                  },
                  addToWatchListButtonBuilder: (builder) =>
                      widget.watchListButton(builder),
                ),
              );
            } else if (state is GetAsyncDataErrorState) {
              return Text(state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void showMessage(
      String message, {
        required BuildContext context,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }
}

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: kHeading6,
        ),
        const SizedBox(
          height: 16,
        ),
        BlocBuilder<TvSeriesRecommendationBloc, GetAsyncDataState>(
          builder: (context, state) {
            if (state is GetAsyncDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetAsyncDataErrorState) {
              return Text(state.message);
            } else if (state is GetAsyncDataLoadedState<List<TvSeries>>) {
              final data = state.data;
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
                          '$tvSeriesRecommendationItemKey-${tvSeries.id}',
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            TvSeriesDetailPage.routeName,
                            arguments: tvSeries.id,
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
              return Container();
            }
          },
        ),
      ],
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final Function(TvSeriesDetail) onAddTvSeriesToWatchList;
  final Function(TvSeriesDetail) onRemoveTvSeriesFromWatchList;
  final Widget Function(Widget Function(BuildContext, GetAsyncDataState))
  addToWatchListButtonBuilder;

  int? get runtime => tvSeries.runtimes.isNotEmpty
      ? tvSeries.runtimes.reduce(
        (value, element) => value + element,
  )
      : null;
  const DetailContent(
      this.tvSeries, {
        super.key,
        required this.onAddTvSeriesToWatchList,
        required this.onRemoveTvSeriesFromWatchList,
        required this.addToWatchListButtonBuilder,
      });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name,
                              style: kHeading5,
                            ),
                            addToWatchListButtonBuilder(
                                  (context, state) {
                                bool isAddedToWatchList;
                                if (state is GetAsyncDataLoadedState<bool>) {
                                  isAddedToWatchList = state.data;
                                } else {
                                  isAddedToWatchList = false;
                                }
                                return ElevatedButton(
                                  onPressed: () {
                                    onTapWatchListButton(
                                      context: context,
                                      isAddedToWatchList: isAddedToWatchList,
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAddedToWatchList
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.add),
                                      const Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              _showGenres(tvSeries.genres),
                            ),
                            Visibility(
                              visible: runtime != null,
                              child: Text(
                                _showDuration(runtime ?? 0),
                              ),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview,
                            ),
                            const SizedBox(height: 16),
                            const RecommendationSection(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  void onTapWatchListButton({
    required BuildContext context,
    required bool isAddedToWatchList,
  }) {
    if (isAddedToWatchList) {
      onRemoveTvSeriesFromWatchList(tvSeries);
    } else {
      onAddTvSeriesToWatchList(tvSeries);
    }
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
