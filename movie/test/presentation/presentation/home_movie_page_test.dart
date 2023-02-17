import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/movie.dart';

import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/events/get_movie_list_event.dart';
import 'package:movie/presentation/bloc/movie_list/now_playing_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/popular_movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/top_rated_movie_list_bloc.dart';
import 'package:movie/presentation/pages/movie_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingMovieListBloc
    extends MockBloc<GetMovieListEvent, GetAsyncDataState>
    implements NowPlayingMovieListBloc {}

class MockPopularMovieListBloc
    extends MockBloc<GetMovieListEvent, GetAsyncDataState>
    implements PopularMovieListBloc {}

class MockTopRatedMovieListBloc
    extends MockBloc<GetMovieListEvent, GetAsyncDataState>
    implements TopRatedMovieListBloc {}

void main() {
  late MockNowPlayingMovieListBloc mockNowPlayingMovieListBloc;
  late MockPopularMovieListBloc mockPopularMovieListBloc;
  late MockTopRatedMovieListBloc mockTopRatedMovieListBloc;

  setUp(
    () {
      mockNowPlayingMovieListBloc = MockNowPlayingMovieListBloc();
      mockPopularMovieListBloc = MockPopularMovieListBloc();
      mockTopRatedMovieListBloc = MockTopRatedMovieListBloc();
    },
  );

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMovieListBloc>(
          create: (context) => mockNowPlayingMovieListBloc,
        ),
        BlocProvider<PopularMovieListBloc>(
          create: (context) => mockPopularMovieListBloc,
        ),
        BlocProvider<TopRatedMovieListBloc>(
          create: (context) => mockTopRatedMovieListBloc,
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
        mockNowPlayingMovieListBloc,
        Stream.value(
          GetAsyncDataLoadingState(),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockPopularMovieListBloc,
        Stream.value(
          GetAsyncDataLoadingState(),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockTopRatedMovieListBloc,
        Stream.value(
          GetAsyncDataLoadingState(),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          HomeMoviePage(
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
        mockNowPlayingMovieListBloc,
        Stream.value(
          GetAsyncDataLoadedState<List<Movie>>(
            data: testMovieList,
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockPopularMovieListBloc,
        Stream.value(
          GetAsyncDataLoadedState<List<Movie>>(
            data: testMovieList,
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockTopRatedMovieListBloc,
        Stream.value(
          GetAsyncDataLoadedState<List<Movie>>(
            data: testMovieList,
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          HomeMoviePage(
            onTapHamburgerButton: () {},
          ),
        ),
      );
      await tester.pump();
      expect(
        find.byType(
          MovieList,
        ),
        findsNWidgets(3),
      );
    },
  );

  testWidgets(
    'Page should show error on every section when there is an error,',
    (tester) async {
      whenListen(
        mockNowPlayingMovieListBloc,
        Stream.value(
          GetAsyncDataErrorState(
            message: 'some error',
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockPopularMovieListBloc,
        Stream.value(
          GetAsyncDataErrorState(
            message: 'some error',
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      whenListen(
        mockTopRatedMovieListBloc,
        Stream.value(
          GetAsyncDataErrorState(
            message: 'some error',
          ),
        ),
        initialState: GetAsyncDataInitialState(),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          HomeMoviePage(
            onTapHamburgerButton: () {},
          ),
        ),
      );
      await tester.pump();
      expect(
        find.text(
          'Fail to retrieve data',
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
  //       mockMovieListNotifier.nowPlayingState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.popularMoviesState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.topRatedMoviesState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.nowPlayingMovies,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockMovieListNotifier.popularMovies,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockMovieListNotifier.topRatedMovies,
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
  //         HomeMoviePage(),
  //       ),
  //     );
  //     await tester.pumpAndSettle();
  //
  //     final ScaffoldState state = tester.firstState(
  //       scaffoldFinder,
  //     );
  //
  //     /// Movies menu test
  //     state.openDrawer();
  //     await tester.pumpAndSettle();
  //     await tester.tap(
  //       find.text('Movies'),
  //       warnIfMissed: false,
  //     );
  //     await tester.pumpAndSettle();
  //     expect(
  //       find.byType(
  //         HomeMoviePage,
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
  //       mockMovieListNotifier.nowPlayingState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.popularMoviesState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.topRatedMoviesState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.nowPlayingMovies,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockMovieListNotifier.popularMovies,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockMovieListNotifier.topRatedMovies,
  //     ).thenReturn(
  //       [],
  //     );
  //     await tester.pumpWidget(
  //       makeTestableWidget(
  //         HomeMoviePage(),
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
  //         PopularMoviesPage.routeName,
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
  //         TopRatedMoviesPage.routeName,
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
  //       mockMovieListNotifier.nowPlayingState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.popularMoviesState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.topRatedMoviesState,
  //     ).thenReturn(
  //       RequestState.loaded,
  //     );
  //     when(
  //       mockMovieListNotifier.nowPlayingMovies,
  //     ).thenReturn(
  //       testMovieList,
  //     );
  //     when(
  //       mockMovieListNotifier.popularMovies,
  //     ).thenReturn(
  //       [],
  //     );
  //     when(
  //       mockMovieListNotifier.topRatedMovies,
  //     ).thenReturn(
  //       [],
  //     );
  //     await tester.pumpWidget(
  //       makeTestableWidget(
  //         HomeMoviePage(),
  //       ),
  //     );
  //     await tester.pump();
  //
  //     final movieItemFinder = find.byKey(
  //       Key(
  //         '$homeMovieItemKey-${testMovieList.first.id}',
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
}
