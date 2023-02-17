import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/events/get_movie_list_event.dart';
import '../../common/constants.dart';
import '../bloc/movie_list/now_playing_movie_list_bloc.dart';
import '../bloc/movie_list/popular_movie_list_bloc.dart';
import '../bloc/movie_list/top_rated_movie_list_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = '/home-movies';

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
    context.read<NowPlayingMovieListBloc>().add(
          GetMovieListEvent(),
        );
    context.read<TopRatedMovieListBloc>().add(
          GetMovieListEvent(),
        );
    context.read<PopularMovieListBloc>().add(
          GetMovieListEvent(),
        );
    super.initState();
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
              BlocBuilder<NowPlayingMovieListBloc, GetAsyncDataState>(
                  builder: (context, state) {
                if (state is GetAsyncDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetAsyncDataLoadedState<List<Movie>>) {
                  return MovieList(
                    state.data,
                    onTapMovieItem: (movie) {
                      widget.onTapMovieItem(
                        movie,
                        context: context,
                      );
                    },
                  );
                } else if (state is GetAsyncDataErrorState) {
                  return const Text('Fail to retrieve data');
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
              BlocBuilder<PopularMovieListBloc, GetAsyncDataState>(
                  builder: (context, state) {
                if (state is GetAsyncDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetAsyncDataLoadedState<List<Movie>>) {
                  return MovieList(
                    state.data,
                    onTapMovieItem: (movie) {
                      widget.onTapMovieItem(
                        movie,
                        context: context,
                      );
                    },
                  );
                } else if (state is GetAsyncDataErrorState) {
                  return const Text('Fail to retrieve data');
                }
                return const SizedBox.shrink();
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  widget.onTapTopRatedSeeMore(context: context);
                },
              ),
              BlocBuilder<TopRatedMovieListBloc, GetAsyncDataState>(
                  builder: (context, state) {
                if (state is GetAsyncDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetAsyncDataLoadedState<List<Movie>>) {
                  return MovieList(
                    state.data,
                    onTapMovieItem: (movie) {
                      widget.onTapMovieItem(
                        movie,
                        context: context,
                      );
                    },
                  );
                } else if (state is GetAsyncDataErrorState) {
                  return const Text('Fail to retrieve data');
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
