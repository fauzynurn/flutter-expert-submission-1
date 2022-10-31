import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/filter_type.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../integration_test/app_test_main.dart';
import '../../../integration_test/search_page_test.mocks.dart';
import '../../dummy_data/dummy_objects.dart';
import '../navigation_test_page.dart';
import '../provider/search_notifier_test.mocks.dart';

@GenerateMocks(
  [
    SearchNotifier,
    SearchMovies,
    SearchTvSeries,
  ],
)
void main() {
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

      await tester.pumpWidget(
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

      await tester.pumpWidget(
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

      await tester.pumpWidget(
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

      await tester.pumpWidget(
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

  testWidgets(
    'Page should redirect to movie detail page'
    'when one movie item is tapped',
    (WidgetTester tester) async {
      when(
        mockSearchNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockSearchNotifier.selectedFilterType,
      ).thenReturn(
        FilterType.movies,
      );
      when(
        mockSearchNotifier.searchResult,
      ).thenReturn(
        testMovieList,
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          SearchPage(),
          notifier: mockSearchNotifier,
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
    'when one tv series item is tapped',
    (WidgetTester tester) async {
      when(
        mockSearchNotifier.state,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockSearchNotifier.selectedFilterType,
      ).thenReturn(
        FilterType.tvSeries,
      );
      when(
        mockSearchNotifier.searchResult,
      ).thenReturn(
        testTvSeriesList,
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          SearchPage(),
          notifier: mockSearchNotifier,
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
