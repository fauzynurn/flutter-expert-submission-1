import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/detail_tv_series_list_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../integration_test/app_test_main.dart';
import '../../dummy_data/dummy_objects.dart';
import '../navigation_test_page.dart';
import 'tv_series_page_test.mocks.dart';

@GenerateMocks(
  [
    TvSeriesListNotifier,
  ],
)
void main() {
  late MockTvSeriesListNotifier mockTvSeriesListNotifier;

  setUp(
    () {
      mockTvSeriesListNotifier = MockTvSeriesListNotifier();
    },
  );

  Widget _makeTestableWidget(Widget body) {
    return AppTestMain(
      body: ChangeNotifierProvider<TvSeriesListNotifier>.value(
        value: mockTvSeriesListNotifier,
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
      ),
    );
  }

  testWidgets(
    'Page should show progress indicator on every section when loading',
    (tester) async {
      when(
        mockTvSeriesListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.Loading,
      );
      when(
        mockTvSeriesListNotifier.popularTvSeriesState,
      ).thenReturn(
        RequestState.Loading,
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeriesState,
      ).thenReturn(
        RequestState.Loading,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesPage(),
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
    'Page should show data on every section when data is available to show',
    (tester) async {
      when(
        mockTvSeriesListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.popularTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.nowPlayingTvSeries,
      ).thenReturn(
        [],
      );
      when(
        mockTvSeriesListNotifier.popularTvSeries,
      ).thenReturn(
        [],
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeries,
      ).thenReturn(
        [],
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesPage(),
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
    'Page should redirect to corresponding page '
    'when is each drawer menu is tapped,',
    (tester) async {
      when(
        mockTvSeriesListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.popularTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.nowPlayingTvSeries,
      ).thenReturn(
        [],
      );
      when(
        mockTvSeriesListNotifier.popularTvSeries,
      ).thenReturn(
        [],
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeries,
      ).thenReturn(
        [],
      );
      final scaffoldFinder = find.byKey(
        const Key(
          tvSeriesListScaffoldKey,
        ),
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesPage(),
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
        find.text('TV Series'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(
          TvSeriesPage,
        ),
        findsOneWidget,
      );

      /// TV Series menu test
      state.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Movies'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          HomeMoviePage.ROUTE_NAME,
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
          WatchlistPage.ROUTE_NAME,
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
          AboutPage.ROUTE_NAME,
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
        mockTvSeriesListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.popularTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.nowPlayingTvSeries,
      ).thenReturn(
        [],
      );
      when(
        mockTvSeriesListNotifier.popularTvSeries,
      ).thenReturn(
        [],
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeries,
      ).thenReturn(
        [],
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesPage(),
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

      /// Now Playing See More button test
      seeMoreWidgets.first.onTap?.call();
      await tester.pumpAndSettle();
      expect(
        find.text(
          DetailTvSeriesListPage.ROUTE_NAME,
        ),
        findsOneWidget,
      );
      await tester.pageBack();

      /// Popular See More button test
      seeMoreWidgets[1].onTap?.call();

      await tester.pumpAndSettle();
      expect(
        find.text(
          DetailTvSeriesListPage.ROUTE_NAME,
        ),
        findsOneWidget,
      );
      await tester.pageBack();

      /// Top Rated See More button test
      seeMoreWidgets.last.onTap?.call();

      await tester.pumpAndSettle();
      expect(
        find.text(
          DetailTvSeriesListPage.ROUTE_NAME,
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
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();
      expect(
        find.text(
          SearchPage.ROUTE_NAME,
        ),
        findsOneWidget,
      );
      await tester.pageBack();
    },
  );

  testWidgets(
    'Page should redirect to tv series detail page'
    'when one tv series item is tapped',
    (WidgetTester tester) async {
      when(
        mockTvSeriesListNotifier.nowPlayingState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.popularTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockTvSeriesListNotifier.nowPlayingTvSeries,
      ).thenReturn(
        testTvSeriesList,
      );
      when(
        mockTvSeriesListNotifier.popularTvSeries,
      ).thenReturn(
        [],
      );
      when(
        mockTvSeriesListNotifier.topRatedTvSeries,
      ).thenReturn(
        [],
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesPage(),
        ),
      );
      await tester.pump();

      final tvSeriesItemFinder = find.byKey(
        Key(
          '$homeTvSeriesItemKey-${testTvSeriesList.first.id}',
        ),
      );

      await tester.tap(
        tvSeriesItemFinder,
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
          '${testTvSeriesList.first.id}',
        ),
        findsOneWidget,
      );
    },
  );
}
