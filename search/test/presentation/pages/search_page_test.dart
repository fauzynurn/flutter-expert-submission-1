import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/domain/use_cases/search_movie.dart';
import 'package:search/domain/use_cases/search_tv_series.dart';
import 'package:search/presentation/bloc/search_movie_bloc.dart';
import 'package:search/presentation/bloc/search_tv_series_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../main/test/dummy_data/dummy_objects.dart';
import '../../../../main/test/presentation/navigation_test_page.dart';
import '../bloc/search_movie_bloc_test.mocks.dart';
import '../bloc/search_tv_series_bloc_test.mocks.dart';

@GenerateMocks(
  [
    SearchMovieBloc,
    SearchTvSeriesBloc,
  ],
)
void main() {
  late SearchMovieBloc searchMovieBloc;
  late SearchTvSeriesBloc searchTvSeriesBloc;

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
              GetAsyncDataLoadedState(
                data: const [],
              ),
            ),
          );

          final searchTextField = find.byKey(
            const Key(
              searchTextFieldKey,
            ),
          );

          final searchListView = find.byKey(
            const Key(
              searchResultKey,
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

      // testWidgets(
      //   'Page should redirect to movie detail page'
      //       'when one movie item is tapped',
      //       (WidgetTester tester) async {
      //     when(
      //       mockSearchNotifier.state,
      //     ).thenReturn(
      //       RequestState.loaded,
      //     );
      //     when(
      //       mockSearchNotifier.selectedFilterType,
      //     ).thenReturn(
      //       FilterType.movies,
      //     );
      //     when(
      //       mockSearchNotifier.searchResult,
      //     ).thenReturn(
      //       testMovieList,
      //     );
      //
      //     await tester.pumpWidget(
      //       _makeTestableWidget(
      //         SearchPage(),
      //         notifier: mockSearchNotifier,
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
