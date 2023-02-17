import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../bloc/tv_series_list/events/get_tv_series_list_event.dart';
import '../bloc/tv_series_list/now_playing_tv_series_list_bloc.dart';
import '../bloc/tv_series_list/popular_tv_series_list_bloc.dart';
import '../bloc/tv_series_list/top_rated_tv_series_list_bloc.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const routeName = '/home-tv-series';

  final VoidCallback onTapHamburgerButton;

  const HomeTvSeriesPage({
    super.key,
    required this.onTapHamburgerButton,
  });

  @override
  HomeTvSeriesPageState createState() => HomeTvSeriesPageState();

  void onTapTvSeriesItem(
    TvSeries tvSeries, {
    required BuildContext context,
  }) {}

  void onTapPopularSeeMore({
    required BuildContext context,
  }) {}

  void onTapTopRatedSeeMore({
    required BuildContext context,
  }) {}

  void onTapSearchButton({
    required BuildContext context,
  }) {}
}

class HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    context.read<NowPlayingTvSeriesListBloc>().add(
          GetTvSeriesListEvent(),
        );
    context.read<TopRatedTvSeriesListBloc>().add(
          GetTvSeriesListEvent(),
        );
    context.read<PopularTvSeriesListBloc>().add(
          GetTvSeriesListEvent(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key(
        tvSeriesListScaffoldKey,
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onTapHamburgerButton,
          icon: const Icon(
            Icons.menu,
          ),
        ),
        title: const Text('Tv Series List'),
        actions: [
          IconButton(
            onPressed: () {
              widget.onTapSearchButton(
                context: context,
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingTvSeriesListBloc, GetAsyncDataState>(
                  builder: (context, state) {
                if (state is GetAsyncDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetAsyncDataLoadedState<List<TvSeries>>) {
                  return TvSeriesList(
                    state.data,
                    onTapTvSeriesItem: (tvSeries) {
                      widget.onTapTvSeriesItem(
                        tvSeries,
                        context: context,
                      );
                    },
                  );
                } else if (state is GetAsyncDataErrorState) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  widget.onTapPopularSeeMore(
                    context: context,
                  );
                },
              ),
              BlocBuilder<PopularTvSeriesListBloc, GetAsyncDataState>(
                  builder: (context, state) {
                if (state is GetAsyncDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetAsyncDataLoadedState<List<TvSeries>>) {
                  return TvSeriesList(
                    state.data,
                    onTapTvSeriesItem: (tvSeries) {
                      widget.onTapTvSeriesItem(
                        tvSeries,
                        context: context,
                      );
                    },
                  );
                } else if (state is GetAsyncDataErrorState) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  widget.onTapTopRatedSeeMore(context: context);
                },
              ),
              BlocBuilder<PopularTvSeriesListBloc, GetAsyncDataState>(
                  builder: (context, state) {
                if (state is GetAsyncDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetAsyncDataLoadedState<List<TvSeries>>) {
                  return TvSeriesList(
                    state.data,
                    onTapTvSeriesItem: (tvSeries) {
                      widget.onTapTvSeriesItem(
                        tvSeries,
                        context: context,
                      );
                    },
                  );
                } else if (state is GetAsyncDataErrorState) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text('See More'),
                Icon(
                  Icons.arrow_forward_ios,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;
  final Function(TvSeries) onTapTvSeriesItem;

  const TvSeriesList(
    this.tvSeries, {
    super.key,
    required this.onTapTvSeriesItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSeriesItem = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: Key('$homeTvSeriesItemKey-${tvSeriesItem.id}'),
              onTap: () => onTapTvSeriesItem(tvSeriesItem),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tvSeriesItem.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
