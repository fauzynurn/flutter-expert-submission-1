import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_list/events/get_movie_list_event.dart';
import '../bloc/movie_list/popular_movie_list_bloc.dart';
import 'movie_detail_page.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  PopularMoviesPageState createState() => PopularMoviesPageState();
}

class PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    context.read<PopularMovieListBloc>().add(
          GetMovieListEvent(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieListBloc, GetAsyncDataState>(
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
