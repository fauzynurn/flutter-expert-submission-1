import 'package:ditonton/features/home_movie/presentation/pages/app_home_movie_page.dart';
import 'package:ditonton/features/movie_detail/presentation/pages/app_movie_detail_page.dart';
import 'package:ditonton/features/watch_list/presentation/pages/app_watch_list_page.dart';
import 'package:ditonton/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie/common/constants.dart';
import '../mock_injection.dart' as di;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Taken from fixtures/movie_list.json
  /// Make sure const below syncs with the json
  const firstMovieId = 663712;

  setUp(
    () {
      di.init();
    },
  );

  /// 1. Open app
  /// 2. Select one movie
  /// 3. Add movie to watch list
  /// 4. Go back to home movie page
  /// 5. Open drawer
  /// 6. Open watch list
  testWidgets(
    'Add movie to watch list',
    (tester) async {
      runApp(
        MyApp(),
      );
      await tester.pumpAndSettle();
      final movieItemFinder = find.byKey(
        Key(
          '$homeMovieItemKey-$firstMovieId',
        ),
      );
      final movieListScaffoldState = find.byKey(
        const Key(
          homeScaffoldKey,
        ),
      );
      final ScaffoldState state = tester.firstState(
        movieListScaffoldState,
      );
      /// Tap movie item
      await tester.tap(
        movieItemFinder,
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(
          AppMovieDetailPage,
        ),
        findsOneWidget,
      );

      /// Tap add to watch list button
      await tester.tap(
        find.text(
          'Watchlist',
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      /// to dismiss snackbar
      await tester.tap(
        find.byIcon(
          Icons.arrow_back,
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(
          AppHomeMoviePage,
        ),
        findsOneWidget,
      );
      state.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(
          'Watchlist',
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(
          AppWatchListPage,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'No data found',
        ),
        findsNothing,
      );
    },
  );
}
