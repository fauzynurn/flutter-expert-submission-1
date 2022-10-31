import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/tv_series_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../test/presentation/navigation_test_page.dart';
import 'app_test_main.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks(
  [
    MovieListNotifier,
  ],
)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockMovieListNotifier mockMovieListNotifier;

  setUp(
    () {
      mockMovieListNotifier = MockMovieListNotifier();
    },
  );

  Widget _makeTestableWidget(Widget body) {
    return AppTestMain(
      body: ChangeNotifierProvider<MovieListNotifier>.value(
        value: mockMovieListNotifier,
        child: MaterialApp(
          home: body,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (_) => NavigationTestPage(
                routeName: routeSettings.name ?? '',
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
      ),
    );
  }

  testWidgets(
    'Page should show progress indicator on every section when loading,',
    (tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.Loading,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.Loading,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.Loading,
      );
      runApp(
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
        RequestState.Loaded,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.Loaded,
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
      runApp(
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
    'Page should redirect to corresponding page when is tapped to specific button,',
    (tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(
        RequestState.Loaded,
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
      await tester.pump();

      /// Open drawer
      final ScaffoldState state = tester.firstState(
        scaffoldFinder,
      );

      state.openDrawer();
      await tester.pump();

      await tester.tap(
        find.text('Movies'),
      );
      await tester.pump();
      expect(
        find.byType(
          HomeMoviePage,
        ),
        findsOneWidget,
      );

      state.openDrawer();
      await tester.pump();
      await tester.tap(
        find.text('TV Series'),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          TvSeriesPage.ROUTE_NAME,
        ),
        findsOneWidget,
      );
      await tester.pageBack();
    },
  );
}
