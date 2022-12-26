import 'package:ditonton/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie/common/constants.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/movie_page.dart';
import 'package:watch_list/presentation/pages/watch_list_page.dart';
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
          movieListScaffoldKey,
        ),
      );
      final ScaffoldState state = tester.firstState(
        movieListScaffoldState,
      );
      await tester.tap(
        movieItemFinder,
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(
          MovieDetailPage,
        ),
        findsOneWidget,
      );

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
      await tester.tap(
        find.byIcon(
          Icons.arrow_back,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(
          HomeMoviePage,
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
          WatchListPage,
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
