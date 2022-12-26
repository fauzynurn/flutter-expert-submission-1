import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_series_page.dart';
import 'package:watch_list/presentation/pages/watch_list_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../navigation_test_page.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks(
  [
    MovieListNotifier,
  ],
)
void main() {
  late MockMovieListNotifier mockMovieListNotifier;

  setUp(
    () {
      mockMovieListNotifier = MockMovieListNotifier();
    },
  );

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieListNotifier>.value(
      value: mockMovieListNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (_) => NavigationTestPage(
              routeName: routeSettings.name ?? '',
              parameter: routeSettings.arguments,
            ),
          );
        },
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
      ),
    );
  }

  testWidgets(
    'Page should show progress indicator on every section when loading,',
    (tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.loading,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.loading,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.loading,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          HomeMoviePage(),
        ),
      );
      await tester.pump();
      expect(
        find.byType(
          CircularProgressIndicator,
        ),
        findsNWidgets(3),
      );
    },
  );

  testWidgets(
    'Page should show data on every section when data is available to show,',
    (tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.nowPlayingMovies,
      ).thenReturn(
        [],
      );
      when(
        mockMovieListNotifier.popularMovies,
      ).thenReturn(
        [],
      );
      when(
        mockMovieListNotifier.topRatedMovies,
      ).thenReturn(
        [],
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          HomeMoviePage(),
        ),
      );
      await tester.pump();
      expect(
        find.byType(
          CircularProgressIndicator,
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Page should show error on every section when there is an error,',
    (tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.error,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.error,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.error,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          HomeMoviePage(),
        ),
      );
      await tester.pump();
      expect(
        find.text(
          'Failed',
        ),
        findsNWidgets(3),
      );
    },
  );

  testWidgets(
    'Page should redirect to corresponding page '
    'when is each drawer menu is tapped,',
    (tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.nowPlayingMovies,
      ).thenReturn(
        [],
      );
      when(
        mockMovieListNotifier.popularMovies,
      ).thenReturn(
        [],
      );
      when(
        mockMovieListNotifier.topRatedMovies,
      ).thenReturn(
        [],
      );
      final scaffoldFinder = find.byKey(
        const Key(
          movieListScaffoldKey,
        ),
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          HomeMoviePage(),
        ),
      );
      await tester.pumpAndSettle();

      final ScaffoldState state = tester.firstState(
        scaffoldFinder,
      );

      /// Movies menu test
      state.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Movies'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(
          HomeMoviePage,
        ),
        findsOneWidget,
      );

      /// TV Series menu test
      state.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('TV Series'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          TvSeriesPage.routeName,
        ),
        findsOneWidget,
      );
      await tester.pageBack();

      /// Watchlist menu test
      state.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Watchlist'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          WatchlistPage.routeName,
        ),
        findsOneWidget,
      );
      await tester.pageBack();

      /// About menu test
      state.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('About'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          AboutPage.routeName,
        ),
        findsOneWidget,
      );
      await tester.pageBack();
    },
  );

  testWidgets(
    'Page should redirect to corresponding page '
    'when is each menu in the screen is tapped,',
    (tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.nowPlayingMovies,
      ).thenReturn(
        [],
      );
      when(
        mockMovieListNotifier.popularMovies,
      ).thenReturn(
        [],
      );
      when(
        mockMovieListNotifier.topRatedMovies,
      ).thenReturn(
        [],
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          HomeMoviePage(),
        ),
      );
      await tester.pumpAndSettle();

      final List<InkWell> seeMoreWidgets = tester
          .widgetList<InkWell>(
            find.byType(
              InkWell,
            ),
          )
          .toList();

      /// Popular  See More button test
      seeMoreWidgets.first.onTap?.call();
      await tester.pumpAndSettle();
      expect(
        find.text(
          PopularMoviesPage.routeName,
        ),
        findsOneWidget,
      );
      await tester.pageBack();

      /// Top Rated See More button test
      seeMoreWidgets.last.onTap?.call();

      await tester.pumpAndSettle();
      expect(
        find.text(
          TopRatedMoviesPage.routeName,
        ),
        findsOneWidget,
      );
      await tester.pageBack();

      await tester.pumpAndSettle();

      /// Search button test
      await tester.tap(
        find.byIcon(
          Icons.search,
        ),
      );

      await tester.pumpAndSettle();
      expect(
        find.text(
          SearchPage.routeName,
        ),
        findsOneWidget,
      );
      await tester.pageBack();
    },
  );

  testWidgets(
    'Page should redirect to movie detail page'
    'when one movie item is tapped',
    (WidgetTester tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.loaded,
      );
      when(
        mockMovieListNotifier.nowPlayingMovies,
      ).thenReturn(
        testMovieList,
      );
      when(
        mockMovieListNotifier.popularMovies,
      ).thenReturn(
        [],
      );
      when(
        mockMovieListNotifier.topRatedMovies,
      ).thenReturn(
        [],
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          HomeMoviePage(),
        ),
      );
      await tester.pump();

      final movieItemFinder = find.byKey(
        Key(
          '$homeMovieItemKey-${testMovieList.first.id}',
        ),
      );

      await tester.tap(
        movieItemFinder,
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          MovieDetailPage.routeName,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '${testMovieList.first.id}',
        ),
        findsOneWidget,
      );
    },
  );
}
