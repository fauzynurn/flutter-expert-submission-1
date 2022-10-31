import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/detail_list_type.dart';
import 'package:ditonton/presentation/pages/detail_tv_series_list_page.dart';
import 'package:ditonton/presentation/provider/detail_tv_series_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../test/dummy_data/dummy_objects.dart';
import 'app_test_main.dart';
import 'detail_tv_series_list_page_test.mocks.dart';

@GenerateMocks(
  [
    DetailTvSeriesListNotifier,
  ],
)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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

      runApp(
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

      runApp(
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

      runApp(
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

      runApp(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.popular,
          ),
        ),
      );

      await tester.pumpAndSettle();

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

      runApp(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.nowPlaying,
          ),
        ),
      );

      await tester.pumpAndSettle();

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

      runApp(
        _makeTestableWidget(
          DetailTvSeriesListPage(
            type: DetailListType.topRated,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(listViewFinder, findsOneWidget);
    },
  );

  // testWidgets('Page should display ListView when data is loaded',
  //     (WidgetTester tester) async {
  //   when(mockDetailTvSeriesListNotifier.state).thenReturn(RequestState.Loaded);
  //   when(mockDetailTvSeriesListNotifier.movies).thenReturn(<Movie>[]);

  //   final listViewFinder = find.byType(ListView);

  //   await tester.pumpWidget(_makeTestableWidget(DetailTvSeriesListPage()));

  //   expect(listViewFinder, findsOneWidget);
  // });

  // testWidgets('Page should display text with message when Error',
  //     (WidgetTester tester) async {
  //   when(mockDetailTvSeriesListNotifier.state).thenReturn(RequestState.Error);
  //   when(mockDetailTvSeriesListNotifier.message).thenReturn('Error message');

  //   final textFinder = find.byKey(Key('error_message'));

  //   await tester.pumpWidget(_makeTestableWidget(DetailTvSeriesListPage()));

  //   expect(textFinder, findsOneWidget);
  // });
}
