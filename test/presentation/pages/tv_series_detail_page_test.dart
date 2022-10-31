import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../navigation_test_page.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([
  TvSeriesDetailNotifier,
])
void main() {
  late MockTvSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSeriesDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockNotifier,
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
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets(
    'Page should show progress indicator when loading data',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(
        RequestState.Loading,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesDetailPage(
            id: 1,
          ),
        ),
      );
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should show error message when fail to load data',
    (WidgetTester tester) async {
      final errorMessage = 'Error message';
      when(mockNotifier.tvSeriesState).thenReturn(
        RequestState.Error,
      );
      when(mockNotifier.message).thenReturn(
        errorMessage,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesDetailPage(
            id: 1,
          ),
        ),
      );
      expect(
        find.text(
          errorMessage,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should show correct tv series detail data',
    (WidgetTester tester) async {
      when(
        mockNotifier.tvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.tvSeries,
      ).thenReturn(
        testTvSeriesDetail,
      );
      when(
        mockNotifier.recommendationState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.tvSeriesRecommendations,
      ).thenReturn(
        [],
      );
      when(
        mockNotifier.isAddedToWatchlist,
      ).thenReturn(
        false,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesDetailPage(
            id: testTvSeriesDetail.id,
          ),
        ),
      );

      /// All of the data displayed should be correct
      expect(
        find.text(
          testTvSeriesDetail.name,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Action',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '2h 0m',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '${testTvSeriesDetail.voteAverage}',
        ),
        findsOneWidget,
      );
      expect(
        find.byIcon(
          Icons.add,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          testTvSeriesDetail.overview,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should show error message when fail to load recommendation',
    (WidgetTester tester) async {
      final errorMessage = 'Error message';
      when(
        mockNotifier.tvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.tvSeries,
      ).thenReturn(
        testTvSeriesDetail,
      );
      when(
        mockNotifier.recommendationState,
      ).thenReturn(
        RequestState.Error,
      );
      when(
        mockNotifier.tvSeriesRecommendations,
      ).thenReturn(
        [],
      );
      when(
        mockNotifier.message,
      ).thenReturn(
        errorMessage,
      );
      when(
        mockNotifier.isAddedToWatchlist,
      ).thenReturn(
        false,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesDetailPage(
            id: testTvSeriesDetail.id,
          ),
        ),
      );

      /// All of the data displayed should be correct
      expect(
        find.text(
          errorMessage,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should redirect to another tv series detail page '
    'when one recommendation item is tapped',
    (WidgetTester tester) async {
      when(
        mockNotifier.tvSeriesState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.tvSeries,
      ).thenReturn(
        testTvSeriesDetail,
      );
      when(
        mockNotifier.recommendationState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.tvSeriesRecommendations,
      ).thenReturn(
        testTvSeriesList,
      );
      when(
        mockNotifier.isAddedToWatchlist,
      ).thenReturn(
        false,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          TvSeriesDetailPage(
            id: testTvSeriesDetail.id,
          ),
        ),
      );
      final InkWell recommendation = tester.widget<InkWell>(
        find.byKey(
          Key(
            '$tvSeriesRecommendationItemKey-${testTvSeriesList.first.id}',
          ),
        ),
      );

      /// Popular  See More button test
      recommendation.onTap?.call();
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
