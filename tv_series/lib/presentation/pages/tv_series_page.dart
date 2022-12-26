import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../provider/tv_series_list_notifier.dart';
import 'package:core/common/state_enum.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const routeName = '/tv-series';

  final VoidCallback onTapHamburgerButton;

  const HomeTvSeriesPage({
    super.key,
    required this.onTapHamburgerButton,
  });

  @override
  HomeMoviePageState createState() => HomeMoviePageState();

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
  void onTapNowPlayingSeeMore({
    required BuildContext context,
  }) {}
  void onTapSearchButton({
    required BuildContext context,
  }) {}
}

class HomeMoviePageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TvSeriesListNotifier>(context, listen: false)
        ..fetchNowPlayingTvSeries()
        ..fetchPopularTvSeries()
        ..fetchTopRatedTvSeries(),
    );
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
        title: const Text('TV Series List'),
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
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () {
                  widget.onTapNowPlayingSeeMore(
                    context: context,
                  );
                },
              ),
              Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.loaded) {
                  return TvSeriesList(
                    data.nowPlayingTvSeries,
                    onTapTvSeriesItem: (tvSeries) {
                      widget.onTapTvSeriesItem(
                        tvSeries,
                        context: context,
                      );
                    },
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  widget.onTapPopularSeeMore(
                    context: context,
                  );
                },
              ),
              Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
                final state = data.popularTvSeriesState;
                if (state == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.loaded) {
                  return TvSeriesList(
                    data.popularTvSeries,
                    onTapTvSeriesItem: (tvSeries) {
                      widget.onTapTvSeriesItem(
                        tvSeries,
                        context: context,
                      );
                    },
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  widget.onTapTopRatedSeeMore(context: context);
                },
              ),
              Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
                final state = data.topRatedTvSeriesState;
                if (state == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.loaded) {
                  return TvSeriesList(
                    data.topRatedTvSeries,
                    onTapTvSeriesItem: (tvSeries) {
                      widget.onTapTvSeriesItem(
                        tvSeries,
                        context: context,
                      );
                    },
                  );
                } else {
                  return const Text('Failed');
                }
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
          final item = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: Key('$homeTvSeriesItemKey-${item.id}'),
              onTap: () => onTapTvSeriesItem(item),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${item.posterPath}',
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



// class TvSeriesPage extends StatefulWidget {
//   static const routeName = '/tv-series';

//   const TvSeriesPage({super.key});
//   @override
//   TvSeriesPageState createState() => TvSeriesPageState();
// }

// class TvSeriesPageState extends State<TvSeriesPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(
//         () => Provider.of<TvSeriesListNotifier>(context, listen: false)
//           ..fetchNowPlayingTvSeries()
//           ..fetchPopularTvSeries()
//           ..fetchTopRatedTvSeries());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: const Key(
//         tvSeriesListScaffoldKey,
//       ),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             const UserAccountsDrawerHeader(
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: AssetImage('assets/circle-g.png'),
//               ),
//               accountName: Text('Ditonton'),
//               accountEmail: Text('ditonton@dicoding.com'),
//             ),
//             ListTile(
//               leading: const Icon(Icons.movie),
//               title: const Text('Movies'),
//               onTap: () {
//                 Navigator.pushNamed(context, HomeMoviePage.routeName);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.tv),
//               title: const Text('TV Series'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.save_alt),
//               title: const Text('Watchlist'),
//               onTap: () {
//                 Navigator.pushNamed(context, WatchlistPage.routeName);
//               },
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.pushNamed(context, AboutPage.routeName);
//               },
//               leading: const Icon(Icons.info_outline),
//               title: const Text('About'),
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: const Text('Ditonton'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, SearchPage.routeName);
//             },
//             icon: const Icon(Icons.search),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSubHeading(
//                 title: 'Now Playing',
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     DetailTvSeriesListPage.routeName,
//                     arguments: DetailListType.nowPlaying,
//                   );
//                 },
//                 // Navigator.pushNamed(context, PopularTvSeriesPage.routeName),
//               ),
//               Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
//                 final state = data.nowPlayingState;
//                 if (state == RequestState.loading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (state == RequestState.loaded) {
//                   return TvSeriesList(data.nowPlayingTvSeries);
//                 } else {
//                   return const Text('Failed');
//                 }
//               }),
//               _buildSubHeading(
//                 title: 'Popular',
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     DetailTvSeriesListPage.routeName,
//                     arguments: DetailListType.popular,
//                   );
//                 },
//                 // Navigator.pushNamed(context, PopularTvSeriesPage.routeName),
//               ),
//               Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
//                 final state = data.popularTvSeriesState;
//                 if (state == RequestState.loading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (state == RequestState.loaded) {
//                   return TvSeriesList(data.popularTvSeries);
//                 } else {
//                   return const Text('Failed');
//                 }
//               }),
//               _buildSubHeading(
//                 title: 'Top Rated',
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     DetailTvSeriesListPage.routeName,
//                     arguments: DetailListType.topRated,
//                   );
//                 },
//                 // Navigator.pushNamed(context, TopRatedTvSeriesPage.routeName),
//               ),
//               Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
//                 final state = data.topRatedTvSeriesState;
//                 if (state == RequestState.loading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (state == RequestState.loaded) {
//                   return TvSeriesList(data.topRatedTvSeries);
//                 } else {
//                   return const Text('Failed');
//                 }
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Row _buildSubHeading({required String title, required Function() onTap}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: kHeading6,
//         ),
//         InkWell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Text('See More'),
//                 const Icon(Icons.arrow_forward_ios)
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TvSeriesList extends StatelessWidget {
//   final List<TvSeries> tvSeriesList;

//   TvSeriesList(this.tvSeriesList);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           final tvSeries = tvSeriesList[index];
//           return Container(
//             padding: const EdgeInsets.all(8),
//             child: InkWell(
//               key: Key('$homeTvSeriesItemKey-${tvSeries.id}'),
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   TvSeriesDetailPage.routeName,
//                   arguments: tvSeries.id,
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.all(Radius.circular(16)),
//                 child: CachedNetworkImage(
//                   imageUrl: '$baseImageUrl${tvSeries.posterPath}',
//                   placeholder: (context, url) => const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//             ),
//           );
//         },
//         itemCount: tvSeriesList.length,
//       ),
//     );
//   }
// }
