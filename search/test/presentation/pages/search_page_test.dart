import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/events/search_result_event.dart';
import 'package:search/presentation/bloc/search_movie_bloc.dart';
import 'package:search/presentation/bloc/search_tv_series_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchMovieBloc extends MockBloc<SearchResultEvent, GetAsyncDataState>
    implements SearchMovieBloc {}

class MockSearchTvSeriesBloc
    extends MockBloc<SearchResultEvent, GetAsyncDataState>
    implements SearchTvSeriesBloc {}

void main() {
  late MockSearchMovieBloc searchMovieBloc;
  late MockSearchTvSeriesBloc searchTvSeriesBloc;

  setUp(
    () {
      searchMovieBloc = MockSearchMovieBloc();
      searchTvSeriesBloc = MockSearchTvSeriesBloc();
    },
  );

  Widget makeTestableWidget(
    Widget body,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchMovieBloc>(
          create: (context) => searchMovieBloc,
        ),
        BlocProvider<SearchTvSeriesBloc>(
          create: (context) => searchTvSeriesBloc,
        ),
      ],
      child: MaterialApp(
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

  group(
    'Search movie test',
    () {
      testWidgets(
        'Should display empty list when no movie result found',
        (WidgetTester tester) async {
          whenListen(
            searchMovieBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<Movie>>(
                data: const [],
              ),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final searchTextField = find.byKey(
            const Key(
              searchTextFieldKey,
            ),
          );

          final searchListView = find.byKey(
            const Key(
              movieSearchResultKey,
            ),
          );

          await tester.pumpWidget(
            makeTestableWidget(
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
            findsNothing,
          );

          expect(
            find.text('No result found'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Should display progress indicator when the result is loading',
        (WidgetTester tester) async {
          whenListen(
            searchMovieBloc,
            Stream.value(
              GetAsyncDataLoadingState(),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final circularProgressFinder = find.byType(
            CircularProgressIndicator,
          );

          await tester.pumpWidget(
            makeTestableWidget(
              SearchPage(),
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
        'Should display search result when the result is available',
        (WidgetTester tester) async {
          whenListen(
            searchMovieBloc,
            Stream.value(
              GetAsyncDataLoadedState(data: testMovieList),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final searchTextField = find.byKey(
            const Key(
              searchTextFieldKey,
            ),
          );

          final searchListView = find.byKey(
            const Key(
              movieSearchResultKey,
            ),
          );

          await tester.pumpWidget(
            makeTestableWidget(
              SearchPage(),
            ),
          );

          /// Enter some query
          await tester.enterText(
            searchTextField,
            'movie title',
          );

          /// Simulate submit button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          expect(
            searchListView,
            findsOneWidget,
          );
        },
      );

      // testWidgets(
      //   'Page should redirect to movie detail page'
      //       'when one movie item is tapped',
      //       (WidgetTester tester) async {
      //         whenListen(
      //           searchMovieBloc,
      //           Stream.value(
      //             GetAsyncDataLoadedState(data: testMovieList),
      //           ),
      //           initialState: GetAsyncDataInitialState(),
      //         );
      //
      //     await tester.pumpWidget(
      //       makeTestableWidget(
      //         SearchPage(),
      //       ),
      //     );
      //
      //     await tester.tap(
      //       find.byWidgetPredicate(
      //             (widget) => widget is CardWithDescription,
      //       ),
      //     );
      //     await tester.pumpAndSettle();
      //
      //     expect(
      //       find.text(
      //         MovieDetailPage.routeName,
      //       ),
      //       findsOneWidget,
      //     );
      //     expect(
      //       find.text(
      //         '${testMovieList.first.id}',
      //       ),
      //       findsOneWidget,
      //     );
      //   },
      // );
    },
  );

  group(
    'Search TV Series test',
    () {
      testWidgets(
        'Should display empty list when no TV Series result found',
        (WidgetTester tester) async {
          whenListen(
            searchMovieBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<Movie>>(
                data: const [],
              ),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            searchTvSeriesBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<TvSeries>>(
                data: const [],
              ),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final tvSeriesFilterOption = find.byWidgetPredicate(
            (element) =>
                element is RadioListTile &&
                element.value == FilterType.tvSeries,
          );

          final filterIconFinder = find.byIcon(Icons.filter_list);

          final searchTextFieldFinder = find.byKey(
            const Key(
              searchTextFieldKey,
            ),
          );

          final searchListView = find.byKey(
            const Key(
              tvSeriesSearchResultKey,
            ),
          );

          await tester.pumpWidget(
            makeTestableWidget(
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

          await tester.pump();

          final TextField searchTextField = tester.firstWidget(
            searchTextFieldFinder,
          );

          expect(
            searchTextField.decoration?.hintText,
            'Search TV Series',
          );

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
            findsNothing,
          );

          expect(
            find.text('No result found'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Should display progress indicator when the result is loading',
        (WidgetTester tester) async {
          whenListen(
            searchMovieBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<Movie>>(
                data: const [],
              ),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            searchTvSeriesBloc,
            Stream.value(
              GetAsyncDataLoadingState(),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final circularProgressFinder = find.byType(
            CircularProgressIndicator,
          );

          final tvSeriesFilterOption = find.byWidgetPredicate(
            (element) =>
                element is RadioListTile &&
                element.value == FilterType.tvSeries,
          );

          final filterIconFinder = find.byIcon(Icons.filter_list);

          final searchTextFieldFinder = find.byKey(
            const Key(
              searchTextFieldKey,
            ),
          );

          await tester.pumpWidget(
            makeTestableWidget(
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

          await tester.pump();

          /// Enter some query
          await tester.enterText(
            searchTextFieldFinder,
            'tv series title',
          );

          /// Simulate submit button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pump();

          expect(
            circularProgressFinder,
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Should display search result when the result is available',
        (WidgetTester tester) async {
          whenListen(
            searchMovieBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<Movie>>(
                data: const [],
              ),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            searchTvSeriesBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<TvSeries>>(data: testTvSeriesList),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final tvSeriesFilterOption = find.byWidgetPredicate(
            (element) =>
                element is RadioListTile &&
                element.value == FilterType.tvSeries,
          );

          final filterIconFinder = find.byIcon(Icons.filter_list);

          final searchTextField = find.byKey(
            const Key(
              searchTextFieldKey,
            ),
          );

          final searchListView = find.byKey(
            const Key(
              tvSeriesSearchResultKey,
            ),
          );

          await tester.pumpWidget(
            makeTestableWidget(
              SearchPage(),
            ),
          );

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

          await tester.pump();

          /// Enter some query
          await tester.enterText(
            searchTextField,
            'tv series title',
          );

          /// Simulate submit button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          expect(
            searchListView,
            findsOneWidget,
          );
        },
      );

      // testWidgets(
      //   'Page should redirect to movie detail page'
      //       'when one movie item is tapped',
      //       (WidgetTester tester) async {
      //         whenListen(
      //           searchTvSeriesBloc,
      //           Stream.value(
      //             GetAsyncDataLoadedState(data: testMovieList),
      //           ),
      //           initialState: GetAsyncDataInitialState(),
      //         );
      //
      //     await tester.pumpWidget(
      //       makeTestableWidget(
      //         SearchPage(),
      //       ),
      //     );
      //
      //     await tester.tap(
      //       find.byWidgetPredicate(
      //             (widget) => widget is CardWithDescription,
      //       ),
      //     );
      //     await tester.pumpAndSettle();
      //
      //     expect(
      //       find.text(
      //         MovieDetailPage.routeName,
      //       ),
      //       findsOneWidget,
      //     );
      //     expect(
      //       find.text(
      //         '${testMovieList.first.id}',
      //       ),
      //       findsOneWidget,
      //     );
      //   },
      // );
    },
  );

  // group(
  //   'Search TV series test',
  //   () {
  //     testWidgets(
  //       'Should display empty list when no TV series result found',
  //       (WidgetTester tester) async {
  //         when(mockSearchTvSeries.execute(any)).thenAnswer(
  //           (_) async => const Right(
  //             [],
  //           ),
  //         );
  //
  //         final tvSeriesFilterOption = find.byWidgetPredicate(
  //           (element) =>
  //               element is RadioListTile &&
  //               element.value == FilterType.tvSeries,
  //         );
  //
  //         final searchTextFieldFinder = find.byKey(
  //           const Key(
  //             searchTextFieldKey,
  //           ),
  //         );
  //
  //         final filterIconFinder = find.byIcon(Icons.filter_list);
  //
  //         final searchListView = find.byKey(
  //           const Key(
  //             searchResultKey,
  //           ),
  //         );
  //
  //         await tester.pumpWidget(
  //           makeTestableWidget(
  //             SearchPage(),
  //           ),
  //         );
  //
  //         await tester.pumpAndSettle();
  //
  //         await tester.tap(
  //           filterIconFinder,
  //         );
  //         await tester.pumpAndSettle();
  //
  //         expect(
  //           tvSeriesFilterOption,
  //           findsOneWidget,
  //         );
  //
  //         await tester.tap(
  //           tvSeriesFilterOption,
  //         );
  //
  //         await tester.pumpAndSettle();
  //
  //         /// Enter some query
  //         await tester.enterText(
  //           searchTextFieldFinder,
  //           'tv series title',
  //         );
  //
  //         /// Simulate submit button
  //         await tester.testTextInput.receiveAction(TextInputAction.done);
  //
  //         await tester.pumpAndSettle();
  //
  //         expect(
  //           searchListView,
  //           findsOneWidget,
  //         );
  //       },
  //     );
  //
  //     testWidgets(
  //       'Should display correct placeholder text when switch to TV Series filter type',
  //           (WidgetTester tester) async {
  //         final tvSeriesFilterOption = find.byWidgetPredicate(
  //               (element) =>
  //           element is RadioListTile && element.value == FilterType.tvSeries,
  //         );
  //
  //         final searchTextFieldFinder = find.byKey(
  //           Key(
  //             searchTextFieldKey,
  //           ),
  //         );
  //
  //         final filterIconFinder = find.byIcon(Icons.filter_list);
  //         final filterTypeBottomSheetFinder = find.byKey(
  //           Key(filterTypeBottomSheetKey),
  //         );
  //
  //         await tester.pumpWidget(
  //           _makeTestableWidget(
  //             SearchPage(),
  //           ),
  //         );
  //
  //         await tester.pumpAndSettle();
  //
  //         await tester.tap(
  //           filterIconFinder,
  //         );
  //         await tester.pumpAndSettle();
  //         expect(
  //           filterTypeBottomSheetFinder,
  //           findsOneWidget,
  //         );
  //         expect(
  //           tvSeriesFilterOption,
  //           findsOneWidget,
  //         );
  //
  //         await tester.tap(
  //           tvSeriesFilterOption,
  //         );
  //
  //         await tester.pump();
  //
  //         final TextField searchTextField = tester.firstWidget(
  //           searchTextFieldFinder,
  //         );
  //         expect(
  //           searchTextField.decoration?.hintText,
  //           'Search TV Series',
  //         );
  //       },
  //     );
  //
  //     testWidgets(
  //       'Page should redirect to tv series detail page'
  //           'when one tv series item is tapped',
  //           (WidgetTester tester) async {
  //         when(
  //           mockSearchNotifier.state,
  //         ).thenReturn(
  //           RequestState.loaded,
  //         );
  //         when(
  //           mockSearchNotifier.selectedFilterType,
  //         ).thenReturn(
  //           FilterType.tvSeries,
  //         );
  //         when(
  //           mockSearchNotifier.searchResult,
  //         ).thenReturn(
  //           testTvSeriesList,
  //         );
  //
  //         await tester.pumpWidget(
  //           _makeTestableWidget(
  //             SearchPage(),
  //             notifier: mockSearchNotifier,
  //           ),
  //         );
  //
  //         await tester.tap(
  //           find.byWidgetPredicate(
  //                 (widget) => widget is CardWithDescription,
  //           ),
  //         );
  //         await tester.pumpAndSettle();
  //
  //         expect(
  //           find.text(
  //             TvSeriesDetailPage.routeName,
  //           ),
  //           findsOneWidget,
  //         );
  //         expect(
  //           find.text(
  //             '${testMovieList.first.id}',
  //           ),
  //           findsOneWidget,
  //         );
  //       },
  //     );
  //   },
  // );
}
