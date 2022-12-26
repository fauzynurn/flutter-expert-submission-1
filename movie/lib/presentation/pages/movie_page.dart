import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../provider/movie_list_notifier.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = '/movies';

  final VoidCallback onTapHamburgerButton;

  const HomeMoviePage({
    super.key,
    required this.onTapHamburgerButton,
  });

  @override
  HomeMoviePageState createState() => HomeMoviePageState();

  void onTapMovieItem(
    Movie movie, {
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

class HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key(
        movieListScaffoldKey,
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onTapHamburgerButton,
          icon: const Icon(
            Icons.menu,
          ),
        ),
        title: const Text('Movie List'),
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
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.loaded) {
                  return MovieList(
                    data.nowPlayingMovies,
                    onTapMovieItem: (movie) {
                      widget.onTapMovieItem(
                        movie,
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
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.popularMoviesState;
                if (state == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.loaded) {
                  return MovieList(
                    data.popularMovies,
                    onTapMovieItem: (movie) {
                      widget.onTapMovieItem(
                        movie,
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
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                if (state == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.loaded) {
                  return MovieList(
                    data.topRatedMovies,
                    onTapMovieItem: (movie) {
                      widget.onTapMovieItem(
                        movie,
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

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onTapMovieItem;
  const MovieList(
    this.movies, {
    super.key,
    required this.onTapMovieItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: Key('$homeMovieItemKey-${movie.id}'),
              onTap: () => onTapMovieItem(movie),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
