import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/events/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_recommendation_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, GetAsyncDataState>
    implements TvSeriesDetailBloc {}

class MockTvSeriesRecommendationBloc
    extends MockBloc<TvSeriesDetailEvent, GetAsyncDataState>
    implements TvSeriesRecommendationBloc {}

void main() {
  late MockTvSeriesDetailBloc movieDetailBloc;
  late MockTvSeriesRecommendationBloc movieRecommendationBloc;

  const errorMessage = 'Error message';

  setUp(() {
    movieDetailBloc = MockTvSeriesDetailBloc();
    movieRecommendationBloc = MockTvSeriesRecommendationBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>(
          create: (context) => movieDetailBloc,
        ),
        BlocProvider<TvSeriesRecommendationBloc>(
          create: (context) => movieRecommendationBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  // testWidgets(
  //     'Watchlist button should display add icon when movie not added to watchlist',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movie).thenReturn(testTvSeriesDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movieRecommendations).thenReturn(<TvSeries>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //
  //   final watchlistButtonIcon = find.byIcon(Icons.add);
  //
  //   await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
  //
  //   expect(watchlistButtonIcon, findsOneWidget);
  // });
  //
  // testWidgets(
  //     'Watchlist button should dispay check icon when movie is added to wathclist',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movie).thenReturn(testTvSeriesDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movieRecommendations).thenReturn(<TvSeries>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(true);
  //
  //   final watchlistButtonIcon = find.byIcon(Icons.check);
  //
  //   await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
  //
  //   expect(watchlistButtonIcon, findsOneWidget);
  // });
  //
  // testWidgets(
  //     'Watchlist button should display Snackbar when added to watchlist',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movie).thenReturn(testTvSeriesDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movieRecommendations).thenReturn(<TvSeries>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //   when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');
  //
  //   final watchlistButton = find.byType(ElevatedButton);
  //
  //   await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
  //
  //   expect(find.byIcon(Icons.add), findsOneWidget);
  //
  //   await tester.tap(watchlistButton);
  //   await tester.pump();
  //
  //   expect(find.byType(SnackBar), findsOneWidget);
  //   expect(find.text('Added to Watchlist'), findsOneWidget);
  // });
  //
  // testWidgets(
  //     'Watchlist button should display AlertDialog when add to watchlist failed',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movie).thenReturn(testTvSeriesDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movieRecommendations).thenReturn(<TvSeries>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //   when(mockNotifier.watchlistMessage).thenReturn('Failed');
  //
  //   final watchlistButton = find.byType(ElevatedButton);
  //
  //   await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
  //
  //   expect(find.byIcon(Icons.add), findsOneWidget);
  //
  //   await tester.tap(watchlistButton);
  //   await tester.pump();
  //
  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });

  group(
    'Detail data test',
    () {
      testWidgets(
        'Page should show progress indicator when loading data',
        (WidgetTester tester) async {
          whenListen(
            movieDetailBloc,
            Stream.value(
              GetAsyncDataLoadingState(),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          await tester.pumpWidget(
            makeTestableWidget(
              const TvSeriesDetailPage(
                id: 1,
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

      testWidgets(
        'Page should show error message when fail to load data',
        (WidgetTester tester) async {
          whenListen(
            movieDetailBloc,
            Stream.value(
              GetAsyncDataErrorState(message: errorMessage),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          await tester.pumpWidget(
            makeTestableWidget(
              const TvSeriesDetailPage(
                id: 1,
              ),
            ),
          );
          await tester.pump();

          expect(
            find.text(
              errorMessage,
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Page should show correct movie detail data',
        (WidgetTester tester) async {
          whenListen(
            movieDetailBloc,
            Stream.value(
              GetAsyncDataLoadedState<TvSeriesDetail>(data: testTvSeriesDetail),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            movieRecommendationBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<TvSeries>>(data: const []),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          await tester.pumpWidget(
            makeTestableWidget(
              TvSeriesDetailPage(
                id: testTvSeriesDetail.id,
              ),
            ),
          );

          await tester.pump();

          /// All of the data displayed should be correct
          expect(
            find.text(
              testTvSeriesDetail.name,
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              'Action',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              '2h 0m',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              '${testTvSeriesDetail.voteAverage}',
            ),
            findsOneWidget,
          );
          // expect(
          //   find.byIcon(
          //     Icons.add,
          //   ),
          //   findsOneWidget,
          // );
          expect(
            find.text(
              testTvSeriesDetail.overview,
            ),
            findsOneWidget,
          );
        },
      );
    },
  );

  group('Recommendation data test', () {
    testWidgets(
      'Page should show error message when fail to load recommendation',
      (WidgetTester tester) async {
        whenListen(
          movieDetailBloc,
          Stream.value(
            GetAsyncDataLoadedState<TvSeriesDetail>(data: testTvSeriesDetail),
          ),
          initialState: GetAsyncDataInitialState(),
        );
        whenListen(
          movieRecommendationBloc,
          Stream.value(
            GetAsyncDataErrorState(message: errorMessage),
          ),
          initialState: GetAsyncDataInitialState(),
        );
        await tester.pumpWidget(
          makeTestableWidget(
            TvSeriesDetailPage(
              id: testTvSeriesDetail.id,
            ),
          ),
        );

        await tester.pump();

        /// All of the data displayed should be correct
        expect(
          find.text(
            errorMessage,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Page should show recommendation data when available',
      (WidgetTester tester) async {
        whenListen(
          movieDetailBloc,
          Stream.value(
            GetAsyncDataLoadedState<TvSeriesDetail>(data: testTvSeriesDetail),
          ),
          initialState: GetAsyncDataInitialState(),
        );
        whenListen(
          movieRecommendationBloc,
          Stream.value(
            GetAsyncDataLoadedState<List<TvSeries>>(data: testTvSeriesList),
          ),
          initialState: GetAsyncDataInitialState(),
        );
        await tester.pumpWidget(
          makeTestableWidget(
            TvSeriesDetailPage(
              id: testTvSeriesDetail.id,
            ),
          ),
        );

        await tester.pump();

        /// All of the data displayed should be correct
        expect(
          find.byKey(
            Key(
              '$tvSeriesRecommendationItemKey-${testTvSeriesList.first.id}',
            ),
          ),
          findsOneWidget,
        );
      },
    );
    //
    // testWidgets(
    //   'Page should redirect to another movie detail page '
    //   'when one recommendation item is tapped',
    //   (WidgetTester tester) async {
    //     when(
    //       mockNotifier.movieState,
    //     ).thenReturn(
    //       RequestState.loaded,
    //     );
    //     when(
    //       mockNotifier.movie,
    //     ).thenReturn(
    //       testTvSeriesDetail,
    //     );
    //     when(
    //       mockNotifier.recommendationState,
    //     ).thenReturn(
    //       RequestState.loaded,
    //     );
    //     when(
    //       mockNotifier.movieRecommendations,
    //     ).thenReturn(
    //       testTvSeriesList,
    //     );
    //     when(
    //       mockNotifier.isAddedToWatchlist,
    //     ).thenReturn(
    //       false,
    //     );
    //     await tester.pumpWidget(
    //       _makeTestableWidget(
    //         TvSeriesDetailPage(
    //           id: testTvSeriesDetail.id,
    //         ),
    //       ),
    //     );
    //     final InkWell recommendation = tester.widget<InkWell>(
    //       find.byKey(
    //         Key(
    //           '$movieRecommendationItemKey-${testTvSeriesList.first.id}',
    //         ),
    //       ),
    //     );
    //
    //     /// Popular  See More button test
    //     recommendation.onTap?.call();
    //     await tester.pumpAndSettle();
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
  });
}
