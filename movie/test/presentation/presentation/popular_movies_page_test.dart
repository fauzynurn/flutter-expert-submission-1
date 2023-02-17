import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/movie_list/popular_movie_list_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.dart';

void main() {
  late MockPopularMovieListBloc popularMovieListBloc;

  setUp(() {
    popularMovieListBloc = MockPopularMovieListBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieListBloc>(
      create: (context) => popularMovieListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    whenListen(
      popularMovieListBloc,
      Stream.value(
        GetAsyncDataLoadingState(),
      ),
      initialState: GetAsyncDataInitialState(),
    );
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(
      makeTestableWidget(
        const PopularMoviesPage(),
      ),
    );

    await tester.pump();
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display ListView when data is loaded',
    (WidgetTester tester) async {
      whenListen(
        popularMovieListBloc,
        Stream.value(
          GetAsyncDataLoadedState<List<Movie>>(data: testMovieList),
        ),
        initialState: GetAsyncDataInitialState(),
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(
        makeTestableWidget(
          const PopularMoviesPage(),
        ),
      );
      await tester.pump();

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when error',
    (WidgetTester tester) async {
      const errorMessage = 'error message';
      whenListen(
        popularMovieListBloc,
        Stream.value(
          GetAsyncDataErrorState(
            message: errorMessage,
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );

      final textFinder = find.text(
        errorMessage,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const PopularMoviesPage(),
        ),
      );

      await tester.pump();
      expect(textFinder, findsOneWidget);
    },
  );
}
