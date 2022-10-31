import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/filter_type.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../test/presentation/provider/search_notifier_test.mocks.dart';
import 'app_test_main.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks(
  [
    MockSearchNotifier,
    SearchMovies,
    SearchTvSeries,
  ],
)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late SearchNotifier searchNotifier;
  late MockSearchNotifier mockSearchNotifier;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(
    () {
      mockSearchMovies = MockSearchMovies();
      mockSearchTvSeries = MockSearchTvSeries();
      mockSearchNotifier = MockSearchNotifier();
      searchNotifier = SearchNotifier(
        searchMovies: mockSearchMovies,
        searchTvSeries: mockSearchTvSeries,
      );
    },
  );

  Widget _makeTestableWidget(Widget body, {SearchNotifier? notifier}) {
    return AppTestMain(
      body: ChangeNotifierProvider<SearchNotifier>.value(
        value: notifier ?? searchNotifier,
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
    'Should display empty list when no movie result found',
    (WidgetTester tester) async {
      when(mockSearchMovies.execute(any)).thenAnswer((_) async => Right([]));

      final searchTextField = find.byKey(
        Key(
          searchTextFieldKey,
        ),
      );

      final searchListView = find.byKey(
        Key(
          searchResultKey,
        ),
      );

      runApp(
        _makeTestableWidget(
          SearchPage(),
        ),
      );
      await tester.pumpAndSettle();

      /// Enter some query
      await tester.enterText(
        searchTextField,
        'movie title',
      );

      /// Simulate submit button
      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      expect(
        searchListView,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should display empty list when no TV series result found',
    (WidgetTester tester) async {
      when(mockSearchTvSeries.execute(any)).thenAnswer(
        (_) async => Right(
          [],
        ),
      );

      final tvSeriesFilterOption = find.byWidgetPredicate(
        (element) =>
            element is RadioListTile && element.value == FilterType.tvSeries,
      );

      final searchTextFieldFinder = find.byKey(
        Key(
          searchTextFieldKey,
        ),
      );

      final filterIconFinder = find.byIcon(Icons.filter_list);

      final searchListView = find.byKey(
        Key(
          searchResultKey,
        ),
      );

      runApp(
        _makeTestableWidget(
          SearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        filterIconFinder,
      );
      await tester.pumpAndSettle();

      expect(
        tvSeriesFilterOption,
        findsOneWidget,
      );

      await tester.tap(
        tvSeriesFilterOption,
      );

      await tester.pumpAndSettle();

      /// Enter some query
      await tester.enterText(
        searchTextFieldFinder,
        'tv series title',
      );

      /// Simulate submit button
      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      expect(
        searchListView,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should display progress indicator when the result is loading',
    (WidgetTester tester) async {
      when(mockSearchNotifier.state).thenReturn(
        RequestState.Loading,
      );
      when(mockSearchNotifier.searchResult).thenReturn(
        [],
      );
      when(mockSearchNotifier.selectedFilterType).thenReturn(
        FilterType.movies,
      );

      final circularProgressFinder = find.byType(
        CircularProgressIndicator,
      );

      runApp(
        _makeTestableWidget(
          SearchPage(),
          notifier: mockSearchNotifier,
        ),
      );

      await tester.pump();

      expect(
        circularProgressFinder,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should display correct placeholder text when switch to TV Series filter type',
    (WidgetTester tester) async {
      final tvSeriesFilterOption = find.byWidgetPredicate(
        (element) =>
            element is RadioListTile && element.value == FilterType.tvSeries,
      );

      final searchTextFieldFinder = find.byKey(
        Key(
          searchTextFieldKey,
        ),
      );

      final filterIconFinder = find.byIcon(Icons.filter_list);
      final filterTypeBottomSheetFinder = find.byKey(
        Key(filterTypeBottomSheetKey),
      );

      runApp(
        _makeTestableWidget(
          SearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        filterIconFinder,
      );
      await tester.pumpAndSettle();
      expect(
        filterTypeBottomSheetFinder,
        findsOneWidget,
      );
      expect(
        tvSeriesFilterOption,
        findsOneWidget,
      );

      await tester.tap(
        tvSeriesFilterOption,
      );

      await tester.pump();

      final TextField searchTextField = tester.firstWidget(
        searchTextFieldFinder,
      );
      expect(
        searchTextField.decoration?.hintText,
        'Search TV Series',
      );
    },
  );
}
