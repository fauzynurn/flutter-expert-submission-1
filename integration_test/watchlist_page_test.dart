import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/filter_type.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../test/dummy_data/dummy_objects.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks(
  [
    GetWatchlistMovies,
    GetWatchlistTvSeries,
  ],
)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late WatchlistNotifier watchlistNotifier;

  setUp(
    () {
      mockGetWatchlistMovies = MockGetWatchlistMovies();
      mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
      watchlistNotifier = WatchlistNotifier(
        getWatchlistMovies: mockGetWatchlistMovies,
        getWatchlistTvSeries: mockGetWatchlistTvSeries,
      );
    },
  );

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistNotifier>.value(
      value: watchlistNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Page should show No Data Found text when there are no movie watch list to show',
    (WidgetTester tester) async {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
        (_) async => Right(
          <Movie>[],
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          WatchlistPage(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No data found'), findsOneWidget);
    },
  );

  testWidgets(
    'Page should show data when there are movie watch list to show',
    (WidgetTester tester) async {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
        (_) async => Right(
          testMovieList,
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          WatchlistPage(),
        ),
      );

      await tester.pump();
      expect(
        find.text('No data found'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Page should show No Data Found text when there are no tv series watch list to show',
    (WidgetTester tester) async {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
        (_) async => Right(
          <Movie>[],
        ),
      );
      when(mockGetWatchlistTvSeries.execute()).thenAnswer(
        (_) async => Right(
          <TvSeries>[],
        ),
      );

      final tvSeriesFilterOption = find.byWidgetPredicate(
        (element) =>
            element is RadioListTile && element.value == FilterType.tvSeries,
      );
      final filterIconFinder = find.byIcon(Icons.filter_list);

      await tester.pumpWidget(
        _makeTestableWidget(
          WatchlistPage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        filterIconFinder,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        tvSeriesFilterOption,
      );

      await tester.pump();

      expect(find.text('No data found'), findsOneWidget);
    },
  );

  testWidgets(
    'Page should show data when there are tv series watch list to show',
    (WidgetTester tester) async {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
        (_) async => Right(
          testMovieList,
        ),
      );
      when(mockGetWatchlistTvSeries.execute()).thenAnswer(
        (_) async => Right(
          testTvSeriesList,
        ),
      );

      final tvSeriesFilterOption = find.byWidgetPredicate(
        (element) =>
            element is RadioListTile && element.value == FilterType.tvSeries,
      );
      final filterIconFinder = find.byIcon(Icons.filter_list);

      await tester.pumpWidget(
        _makeTestableWidget(
          WatchlistPage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        filterIconFinder,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        tvSeriesFilterOption,
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();
      expect(
        find.text('No data found'),
        findsNothing,
      );
    },
  );
}
