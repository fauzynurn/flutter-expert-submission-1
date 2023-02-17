import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/presentation/bloc/events/get_watch_list_event.dart';
import 'package:watch_list/presentation/bloc/movie/get_movie_watch_list_bloc.dart';
import 'package:watch_list/presentation/bloc/tv_series/get_tv_series_watch_list_bloc.dart';
import 'package:watch_list/presentation/pages/watch_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetMovieWatchListBloc
    extends MockBloc<GetWatchListEvent, GetAsyncDataState>
    implements GetMovieWatchListBloc {}

class MockGetTvSeriesWatchListBloc
    extends MockBloc<GetWatchListEvent, GetAsyncDataState>
    implements GetTvSeriesWatchListBloc {}

void main() {
  late MockGetMovieWatchListBloc getMovieWatchListBloc;
  late MockGetTvSeriesWatchListBloc getTvSeriesWatchListBloc;

  setUp(
    () {
      getMovieWatchListBloc = MockGetMovieWatchListBloc();
      getTvSeriesWatchListBloc = MockGetTvSeriesWatchListBloc();
    },
  );

  Widget makeTestableWidget(
    Widget body,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetMovieWatchListBloc>(
          create: (context) => getMovieWatchListBloc,
        ),
        BlocProvider<GetTvSeriesWatchListBloc>(
          create: (context) => getTvSeriesWatchListBloc,
        ),
      ],
      child: MaterialApp(
        // onGenerateRoute: (routeSettings) {
        //   return MaterialPageRoute(
        //     builder: (_) => NavigationTestPage(
        //       d: routeSettings.name ?? '',
        //       parameter: routeSettings.arguments,
        //     ),
        //   );
        // },
        home: body,
      ),
    );
  }

  group('Movie watch list test', () {
    testWidgets(
      'Page should show No Data Found text when there are no movie watch list to show',
      (WidgetTester tester) async {
        whenListen(
          getMovieWatchListBloc,
          Stream.value(
            GetAsyncDataLoadedState<List<Movie>>(data: const []),
          ),
          initialState: GetAsyncDataInitialState(),
        );

        await tester.pumpWidget(
          makeTestableWidget(
            WatchListPage(
              onTapHamburgerButton: () {},
            ),
          ),
        );

        await tester.pump();
        expect(find.text('No Data'), findsOneWidget);
      },
    );

    testWidgets(
      'Page should show data when there are movie watch list to show',
      (WidgetTester tester) async {
        whenListen(
          getMovieWatchListBloc,
          Stream.value(
            GetAsyncDataLoadedState<List<Movie>>(data: testMovieList),
          ),
          initialState: GetAsyncDataInitialState(),
        );

        await tester.pumpWidget(
          makeTestableWidget(
            WatchListPage(
              onTapHamburgerButton: () {},
            ),
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
        whenListen(
          getMovieWatchListBloc,
          Stream.value(
            GetAsyncDataLoadingState(),
          ),
          initialState: GetAsyncDataInitialState(),
        );

        await tester.pumpWidget(
          makeTestableWidget(
            WatchListPage(
              onTapHamburgerButton: () {},
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        );
      },
    );
  });

  group(
    'Tv series watch list test',
    () {
      testWidgets(
        'Page should show No Data Found text when there are no tv series watch list to show',
        (WidgetTester tester) async {
          whenListen(
            getMovieWatchListBloc,
            Stream.value(
              GetAsyncDataInitialState(),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            getTvSeriesWatchListBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<TvSeries>>(data: const []),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final tvSeriesFilterOption = find.byWidgetPredicate(
            (element) =>
                element is RadioListTile &&
                element.value == FilterType.tvSeries,
          );

          final filterIconFinder = find.byIcon(Icons.filter_list);

          await tester.pumpWidget(
            makeTestableWidget(
              WatchListPage(
                onTapHamburgerButton: () {},
              ),
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
            warnIfMissed: false,
          );

          await tester.pump();

          expect(find.text('No Data'), findsOneWidget);
        },
      );

      testWidgets(
        'Page should show data when there are movie watch list to show',
        (WidgetTester tester) async {
          whenListen(
            getMovieWatchListBloc,
            Stream.value(
              GetAsyncDataInitialState(),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            getTvSeriesWatchListBloc,
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

          await tester.pumpWidget(
            makeTestableWidget(
              WatchListPage(
                onTapHamburgerButton: () {},
              ),
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
            warnIfMissed: false,
          );

          await tester.pump();

          expect(
            find.text('No Data'),
            findsNothing,
          );
        },
      );

      testWidgets(
        'Page should show progress indicator when loading',
        (WidgetTester tester) async {
          whenListen(
            getMovieWatchListBloc,
            Stream.value(
              GetAsyncDataInitialState(),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            getTvSeriesWatchListBloc,
            Stream.value(
              GetAsyncDataLoadingState(),
            ),
            initialState: GetAsyncDataInitialState(),
          );

          final tvSeriesFilterOption = find.byWidgetPredicate(
            (element) =>
                element is RadioListTile &&
                element.value == FilterType.tvSeries,
          );

          final filterIconFinder = find.byIcon(Icons.filter_list);

          await tester.pumpWidget(
            makeTestableWidget(
              WatchListPage(
                onTapHamburgerButton: () {},
              ),
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
            warnIfMissed: false,
          );

          await tester.pump();

          expect(
            find.byType(CircularProgressIndicator),
            findsOneWidget,
          );
        },
      );
    },
  );
}

// testWidgets(
//   'Page should show No Data Found text when there are no tv series watch list to show',
//       (WidgetTester tester) async {
//     when(mockGetWatchlistMovies.execute()).thenAnswer(
//           (_) async => Right(
//         <Movie>[],
//       ),
//     );
//     when(mockGetWatchlistTvSeries.execute()).thenAnswer(
//           (_) async => Right(
//         <TvSeries>[],
//       ),
//     );
//
//     final tvSeriesFilterOption = find.byWidgetPredicate(
//           (element) =>
//       element is RadioListTile && element.value == FilterType.tvSeries,
//     );
//     final filterIconFinder = find.byIcon(Icons.filter_list);
//
//     await tester.pumpWidget(
//       _makeTestableWidget(
//         WatchlistPage(),
//       ),
//     );
//     await tester.pumpAndSettle();
//
//     await tester.tap(
//       filterIconFinder,
//     );
//     await tester.pumpAndSettle();
//     await tester.tap(
//       tvSeriesFilterOption,
//     );
//
//     await tester.pump();
//
//     expect(find.text('No data found'), findsOneWidget);
//   },
// );
//
// testWidgets(
//   'Page should show data when there are tv series watch list to show',
//       (WidgetTester tester) async {
//     when(mockGetWatchlistMovies.execute()).thenAnswer(
//           (_) async => Right(
//         testMovieList,
//       ),
//     );
//     when(mockGetWatchlistTvSeries.execute()).thenAnswer(
//           (_) async => Right(
//         testTvSeriesList,
//       ),
//     );
//
//     final tvSeriesFilterOption = find.byWidgetPredicate(
//           (element) =>
//       element is RadioListTile && element.value == FilterType.tvSeries,
//     );
//     final filterIconFinder = find.byIcon(Icons.filter_list);
//
//     await tester.pumpWidget(
//       _makeTestableWidget(
//         WatchlistPage(),
//       ),
//     );
//     await tester.pump();
//
//     await tester.tap(
//       filterIconFinder,
//     );
//     await tester.pump();
//     await tester.tap(
//       tvSeriesFilterOption,
//       warnIfMissed: false,
//     );
//
//     await tester.pump();
//     expect(
//       find.text('No data found'),
//       findsNothing,
//     );
//   },
// );
//
// testWidgets(
//   'Page should redirect to movie detail page'
//       'when one movie item is tapped',
//       (WidgetTester tester) async {
//     when(mockWatchlistNotifier.watchlistState).thenReturn(
//       RequestState.loaded,
//     );
//     when(mockWatchlistNotifier.selectedFilterType).thenReturn(
//       FilterType.movies,
//     );
//     when(mockWatchlistNotifier.watchlistMovies).thenReturn(
//       testMovieList,
//     );
//
//     await tester.pumpWidget(
//       _makeTestableWidget(
//         WatchlistPage(),
//         notifier: mockWatchlistNotifier,
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
//
// testWidgets(
//   'Page should redirect to movie detail page'
//       'when one tv serires item is tapped',
//       (WidgetTester tester) async {
//     when(mockWatchlistNotifier.watchlistState).thenReturn(
//       RequestState.loaded,
//     );
//     when(mockWatchlistNotifier.selectedFilterType).thenReturn(
//       FilterType.tvSeries,
//     );
//     when(mockWatchlistNotifier.watchlistTvSeries).thenReturn(
//       testTvSeriesList,
//     );
//
//     await tester.pumpWidget(
//       _makeTestableWidget(
//         WatchlistPage(),
//         notifier: mockWatchlistNotifier,
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
//         TvSeriesDetailPage.routeName,
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
