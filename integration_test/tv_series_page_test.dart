import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_series_page.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'app_test_main.dart';
import 'tv_series_page_test.mocks.dart';

@GenerateMocks(
  [
    TvSeriesListNotifier,
  ],
)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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
      runApp(
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
      runApp(
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
}
