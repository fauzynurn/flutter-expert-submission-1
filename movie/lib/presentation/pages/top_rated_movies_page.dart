import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_list/events/get_movie_list_event.dart';
import '../bloc/movie_list/top_rated_movie_list_bloc.dart';
import 'movie_detail_page.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  TopRatedMoviesPageState createState() => TopRatedMoviesPageState();
}

class TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    context.read<TopRatedMovieListBloc>().add(
          GetMovieListEvent(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieListBloc, GetAsyncDataState>(
            builder: (context, state) {
          if (state is GetAsyncDataLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetAsyncDataLoadedState<List<Movie>>) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.data[index];
                return CardWithDescription(
                  title: movie.title ?? '',
                  overview: movie.overview ?? '',
                  posterPath: movie.posterPath ?? '',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MovieDetailPage.routeName,
                      arguments: movie.id,
                    );
                  },
                );
              },
              itemCount: state.data.length,
            );
          } else if (state is GetAsyncDataErrorState) {
            return Text(state.message);
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
