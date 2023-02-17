import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv_series.dart';

import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/events/get_tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/now_playing_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/popular_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/top_rated_tv_series_list_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTvSeriesListBloc
    extends MockBloc<GetTvSeriesListEvent, GetAsyncDataState>
    implements NowPlayingTvSeriesListBloc {}

class MockPopularTvSeriesListBloc
    extends MockBloc<GetTvSeriesListEvent, GetAsyncDataState>
    implements PopularTvSeriesListBloc {}

class MockTopRatedTvSeriesListBloc
    extends MockBloc<GetTvSeriesListEvent, GetAsyncDataState>
    implements TopRatedTvSeriesListBloc {}

void main() {
  late MockNowPlayingTvSeriesListBloc mockNowPlayingTvSeriesListBloc;
  late MockPopularTvSeriesListBloc mockPopularTvSeriesListBloc;
  late MockTopRatedTvSeriesListBloc mockTopRatedTvSeriesListBloc;

  setUp(
    () {
      mockNowPlayingTvSeriesListBloc = MockNowPlayingTvSeriesListBloc();
      mockPopularTvSeriesListBloc = MockPopularTvSeriesListBloc();
      mockTopRatedTvSeriesListBloc = MockTopRatedTvSeriesListBloc();
    },
  );

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTvSeriesListBloc>(
          create: (context) => mockNowPlayingTvSeriesListBloc,
        ),
        BlocProvider<PopularTvSeriesListBloc>(
          create: (context) => mockPopularTvSeriesListBloc,
        ),
        BlocProvider<TopRatedTvSeriesListBloc>(
          create: (context) => mockTopRatedTvSeriesListBloc,
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

  testWidgets(
    'Page should show progress indicator on every section when loading,',
    (tester) async {
      whenListen(
        mockNowPlayingTvSeriesListBloc,
        Stream.value(
          GetAsyncDataLoadingState(),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockPopularTvSeriesListBloc,
        Stream.value(
          GetAsyncDataLoadingState(),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockTopRatedTvSeriesListBloc,
        Stream.value(
          GetAsyncDataLoadingState(),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          HomeTvSeriesPage(
            onTapHamburgerButton: () {},
          ),
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
      whenListen(
        mockNowPlayingTvSeriesListBloc,
        Stream.value(
          GetAsyncDataLoadedState<List<TvSeries>>(
            data: testTvSeriesList,
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockPopularTvSeriesListBloc,
        Stream.value(
          GetAsyncDataLoadedState<List<TvSeries>>(
            data: testTvSeriesList,
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockTopRatedTvSeriesListBloc,
        Stream.value(
          GetAsyncDataLoadedState<List<TvSeries>>(
            data: testTvSeriesList,
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          HomeTvSeriesPage(
            onTapHamburgerButton: () {},
          ),
        ),
      );
      await tester.pump();
      expect(
        find.byType(
          TvSeriesList,
        ),
        findsNWidgets(3),
      );
    },
  );

  testWidgets(
    'Page should show error on every section when there is an error,',
    (tester) async {
      whenListen(
        mockNowPlayingTvSeriesListBloc,
        Stream.value(
          GetAsyncDataErrorState(
            message: 'some error',
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockPopularTvSeriesListBloc,
        Stream.value(
          GetAsyncDataErrorState(
            message: 'some error',
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockTopRatedTvSeriesListBloc,
        Stream.value(
          GetAsyncDataErrorState(
            message: 'some error',
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          HomeTvSeriesPage(
            onTapHamburgerButton: () {},
          ),
        ),
      );
      await tester.pump();
      expect(
        find.text(
          'some error',
        ),
        findsNWidgets(3),
      );
    },
  );
  //
  // testWidgets(
  //   'Page should redirect to corresponding page '
  //   'when is each drawer menu is tapped,',
  //   (tester) async {
  //     when(
  //       mockTvSeriesListNotifier.nowPlayingState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.popularTvSeriessState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.topRatedTvSeriessState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.nowPlayingTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockTvSeriesListNotifier.popularTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockTvSeriesListNotifier.topRatedTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     final scaffoldFinder = find.byKey(
  //       const Key(
  //         movieListScaffoldKey,
  //       ),
  //     );
  //     await tester.pumpWidget(
  //       makeTestableWidget(
  //         HomeTvSeriesPage(),
  //       ),
  //     );
  //     await tester.pumpAndSettle();
  //
  //     final ScaffoldState state = tester.firstState(
  //       scaffoldFinder,
  //     );
  //
  //     /// TvSeriess menu test
  //     state.openDrawer();
  //     await tester.pumpAndSettle();
  //     await tester.tap(
  //       find.text('TvSeriess'),
  //       warnIfMissed: false,
  //     );
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.byType(
  //         HomeTvSeriesPage,
  //       ),
  //       findsOneWidget,
  //     );
  //
  //     /// TV Series menu test
  //     state.openDrawer();
  //     await tester.pumpAndSettle();
  //     await tester.tap(
  //       find.text('TV Series'),
  //       warnIfMissed: false,
  //     );
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.text(
  //         TvSeriesPage.routeName,
  //       ),
  //       findsOneWidget,
  //     );
  //     await tester.pageBack();
  //
  //     /// Watchlist menu test
  //     state.openDrawer();
  //     await tester.pumpAndSettle();
  //     await tester.tap(
  //       find.text('Watchlist'),
  //       warnIfMissed: false,
  //     );
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.text(
  //         WatchlistPage.routeName,
  //       ),
  //       findsOneWidget,
  //     );
  //     await tester.pageBack();
  //
  //     /// About menu test
  //     state.openDrawer();
  //     await tester.pumpAndSettle();
  //     await tester.tap(
  //       find.text('About'),
  //       warnIfMissed: false,
  //     );
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.text(
  //         AboutPage.routeName,
  //       ),
  //       findsOneWidget,
  //     );
  //     await tester.pageBack();
  //   },
  // );
  //
  // testWidgets(
  //   'Page should redirect to corresponding page '
  //   'when is each menu in the screen is tapped,',
  //   (tester) async {
  //     when(
  //       mockTvSeriesListNotifier.nowPlayingState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.popularTvSeriessState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.topRatedTvSeriessState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.nowPlayingTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockTvSeriesListNotifier.popularTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockTvSeriesListNotifier.topRatedTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     await tester.pumpWidget(
  //       makeTestableWidget(
  //         HomeTvSeriesPage(),
  //       ),
  //     );
  //     await tester.pumpAndSettle();
  //
  //     final List<InkWell> seeMoreWidgets = tester
  //         .widgetList<InkWell>(
  //           find.byType(
  //             InkWell,
  //           ),
  //         )
  //         .toList();
  //
  //     /// Popular  See More button test
  //     seeMoreWidgets.first.onTap?.call();
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.text(
  //         PopularTvSeriessPage.routeName,
  //       ),
  //       findsOneWidget,
  //     );
  //     await tester.pageBack();
  //
  //     /// Top Rated See More button test
  //     seeMoreWidgets.last.onTap?.call();
  //
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.text(
  //         TopRatedTvSeriessPage.routeName,
  //       ),
  //       findsOneWidget,
  //     );
  //     await tester.pageBack();
  //
  //     await tester.pumpAndSettle();
  //
  //     /// Search button test
  //     await tester.tap(
  //       find.byIcon(
  //         Icons.search,
  //       ),
  //     );
  //
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.text(
  //         SearchPage.routeName,
  //       ),
  //       findsOneWidget,
  //     );
  //     await tester.pageBack();
  //   },
  // );
  //
  // testWidgets(
  //   'Page should redirect to movie detail page'
  //   'when one movie item is tapped',
  //   (WidgetTester tester) async {
  //     when(
  //       mockTvSeriesListNotifier.nowPlayingState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.popularTvSeriessState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.topRatedTvSeriessState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.nowPlayingTvSeriess,
  //     ).thenReturn(
  //       testTvSeriesList,
  //     );
  //     when(
  //       mockTvSeriesListNotifier.popularTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockTvSeriesListNotifier.topRatedTvSeriess,
  //     ).thenReturn(
  //       [],
  //     );
  //     await tester.pumpWidget(
  //       makeTestableWidget(
  //         HomeTvSeriesPage(),
  //       ),
  //     );
  //     await tester.pump();
  //
  //     final movieItemFinder = find.byKey(
  //       Key(
  //         '$homeTvSeriesItemKey-${testTvSeriesList.first.id}',
  //       ),
  //     );
  //
  //     await tester.tap(
  //       movieItemFinder,
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
  //         '${testTvSeriesList.first.id}',
  //       ),
  //       findsOneWidget,
  //     );
  //   },
  // );
}
