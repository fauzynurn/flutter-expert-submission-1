import 'package:dartz/dartz.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/filter_type.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:ditonton/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../navigation_test_page.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks(
  [
    GetWatchlistMovies,
    GetWatchlistTvSeries,
    WatchlistNotifier,
  ],
)
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockWatchlistNotifier mockWatchlistNotifier;
  late WatchlistNotifier watchlistNotifier;

  setUp(
    () {
      mockGetWatchlistMovies = MockGetWatchlistMovies();
      mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
      mockWatchlistNotifier = MockWatchlistNotifier();
      watchlistNotifier = WatchlistNotifier(
        getWatchlistMovies: mockGetWatchlistMovies,
        getWatchlistTvSeries: mockGetWatchlistTvSeries,
      );
    },
  );

  Widget _makeTestableWidget(Widget body, {WatchlistNotifier? notifier}) {
    return ChangeNotifierProvider<WatchlistNotifier>.value(
      value: notifier ?? watchlistNotifier,
      child: MaterialApp(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (_) => NavigationTestPage(
              routeName: routeSettings.name ?? '',
              parameter: routeSettings.arguments,
            ),
          );
        },
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
    'Page should show progress indicator when loading',
    (WidgetTester tester) async {
      when(mockWatchlistNotifier.watchlistState)
          .thenReturn(RequestState.Loading);

      await tester.pumpWidget(
        _makeTestableWidget(
          WatchlistPage(),
          notifier: mockWatchlistNotifier,
        ),
      );
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
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
      await tester.pump();

      await tester.tap(
        filterIconFinder,
      );
      await tester.pump();
      await tester.tap(
        tvSeriesFilterOption,
        warnIfMissed: false,
      );

      await tester.pump();
      expect(
        find.text('No data found'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Page should redirect to movie detail page'
    'when one movie item is tapped',
    (WidgetTester tester) async {
      when(mockWatchlistNotifier.watchlistState).thenReturn(
        RequestState.Loaded,
      );
      when(mockWatchlistNotifier.selectedFilterType).thenReturn(
        FilterType.movies,
      );
      when(mockWatchlistNotifier.watchlistMovies).thenReturn(
        testMovieList,
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          WatchlistPage(),
          notifier: mockWatchlistNotifier,
        ),
      );

      await tester.tap(
        find.byWidgetPredicate(
          (widget) => widget is CardWithDescription,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          MovieDetailPage.ROUTE_NAME,
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

  testWidgets(
    'Page should redirect to movie detail page'
    'when one tv serires item is tapped',
    (WidgetTester tester) async {
      when(mockWatchlistNotifier.watchlistState).thenReturn(
        RequestState.Loaded,
      );
      when(mockWatchlistNotifier.selectedFilterType).thenReturn(
        FilterType.tvSeries,
      );
      when(mockWatchlistNotifier.watchlistTvSeries).thenReturn(
        testTvSeriesList,
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          WatchlistPage(),
          notifier: mockWatchlistNotifier,
        ),
      );

      await tester.tap(
        find.byWidgetPredicate(
          (widget) => widget is CardWithDescription,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          TvSeriesDetailPage.ROUTE_NAME,
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
