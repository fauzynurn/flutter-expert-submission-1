import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../navigation_test_page.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (_) => NavigationTestPage(
              routeName: routeSettings.name ?? '',
              parameter: routeSettings.arguments,
            ),
          );
        },
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
    'Page should show progress indicator when loading data',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(
        RequestState.Loading,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          MovieDetailPage(
            id: 1,
          ),
        ),
      );
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should show error message when fail to load data',
    (WidgetTester tester) async {
      final errorMessage = 'Error message';
      when(mockNotifier.movieState).thenReturn(
        RequestState.Error,
      );
      when(mockNotifier.message).thenReturn(
        errorMessage,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          MovieDetailPage(
            id: 1,
          ),
        ),
      );
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
      when(
        mockNotifier.movieState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.movie,
      ).thenReturn(
        testMovieDetail,
      );
      when(
        mockNotifier.recommendationState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.movieRecommendations,
      ).thenReturn(
        [],
      );
      when(
        mockNotifier.isAddedToWatchlist,
      ).thenReturn(
        false,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          MovieDetailPage(
            id: testMovieDetail.id,
          ),
        ),
      );

      /// All of the data displayed should be correct
      expect(
        find.text(
          testMovieDetail.title,
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
          '${testMovieDetail.voteAverage}',
        ),
        findsOneWidget,
      );
      expect(
        find.byIcon(
          Icons.add,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          testMovieDetail.overview,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Page should show error message when fail to load recommendation',
    (WidgetTester tester) async {
      final errorMessage = 'Error message';
      when(
        mockNotifier.movieState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.movie,
      ).thenReturn(
        testMovieDetail,
      );
      when(
        mockNotifier.recommendationState,
      ).thenReturn(
        RequestState.Error,
      );
      when(
        mockNotifier.movieRecommendations,
      ).thenReturn(
        [],
      );
      when(
        mockNotifier.message,
      ).thenReturn(
        errorMessage,
      );
      when(
        mockNotifier.isAddedToWatchlist,
      ).thenReturn(
        false,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          MovieDetailPage(
            id: testMovieDetail.id,
          ),
        ),
      );

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
    'Page should redirect to another movie detail page '
    'when one recommendation item is tapped',
    (WidgetTester tester) async {
      when(
        mockNotifier.movieState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.movie,
      ).thenReturn(
        testMovieDetail,
      );
      when(
        mockNotifier.recommendationState,
      ).thenReturn(
        RequestState.Loaded,
      );
      when(
        mockNotifier.movieRecommendations,
      ).thenReturn(
        testMovieList,
      );
      when(
        mockNotifier.isAddedToWatchlist,
      ).thenReturn(
        false,
      );
      await tester.pumpWidget(
        _makeTestableWidget(
          MovieDetailPage(
            id: testMovieDetail.id,
          ),
        ),
      );
      final InkWell recommendation = tester.widget<InkWell>(
        find.byKey(
          Key(
            '$movieRecommendationItemKey-${testMovieList.first.id}',
          ),
        ),
      );

      /// Popular  See More button test
      recommendation.onTap?.call();
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
}
