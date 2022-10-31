import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/detail_list_type.dart';
import 'package:ditonton/presentation/pages/detail_tv_series_list_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/detail_tv_series_list_notifier.dart';
import 'package:ditonton/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../integration_test/app_test_main.dart';
import '../../dummy_data/dummy_objects.dart';
import '../navigation_test_page.dart';
import 'detail_tv_series_list_page_test.mocks.dart';

@GenerateMocks(
  [
    DetailTvSeriesListNotifier,
  ],
)
void main() {
  late DetailTvSeriesListNotifier mockDetailTvSeriesListNotifier;

  setUp(
    () {
      mockDetailTvSeriesListNotifier = MockDetailTvSeriesListNotifier();
    },
  );

  Widget _makeTestableWidget(Widget body) {
    return AppTestMain(
      body: ChangeNotifierProvider<DetailTvSeriesListNotifier>.value(
        value: mockDetailTvSeriesListNotifier,
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
    'Page should display correct app bar title (popular)',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );

      when(
        mockDetailTvSeriesListNotifier.tvSeries,
      ).thenReturn(
        [],
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.popular,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Popular TV Series'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should display correct app bar title (now playing)',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );

      when(
        mockDetailTvSeriesListNotifier.tvSeries,
      ).thenReturn(
        [],
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.nowPlaying,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Now Playing TV Series'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should display correct app bar title (top rated)',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );

      when(
        mockDetailTvSeriesListNotifier.tvSeries,
      ).thenReturn(
        [],
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.topRated,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Top Rated TV Series'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should display center progress bar when loading',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loading,
      );

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.popular,
          ),
        ),
      );

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display ListView when data is loaded (popular)',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );

      when(
        mockDetailTvSeriesListNotifier.tvSeries,
      ).thenReturn(
        testTvSeriesList,
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.popular,
          ),
        ),
      );

      await tester.pump();

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display ListView when data is loaded (now playing)',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );

      when(
        mockDetailTvSeriesListNotifier.tvSeries,
      ).thenReturn(
        testTvSeriesList,
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.nowPlaying,
          ),
        ),
      );

      await tester.pump();

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display ListView when data is loaded (top rated)',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );

      when(
        mockDetailTvSeriesListNotifier.tvSeries,
      ).thenReturn(
        testTvSeriesList,
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.topRated,
          ),
        ),
      );

      await tester.pump();

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should redirect to tv series detail page when'
    ' tv series item is tapped',
    (WidgetTester tester) async {
      when(
        mockDetailTvSeriesListNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );

      when(
        mockDetailTvSeriesListNotifier.tvSeries,
      ).thenReturn(
        testTvSeriesList,
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.topRated,
          ),
        ),
      );

      await tester.pump();

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
          '${testTvSeriesList.first.id}',
        ),
        findsOneWidget,
      );
    },
  );
}
