import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/common/constants.dart';
import 'package:movie/presentation/bloc/movie_detail/events/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_recommendation_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, GetAsyncDataState>
    implements MovieDetailBloc {}

class MockMovieRecommendationBloc
    extends MockBloc<MovieDetailEvent, GetAsyncDataState>
    implements MovieRecommendationBloc {}

void main() {
  late MockMovieDetailBloc movieDetailBloc;
  late MockMovieRecommendationBloc movieRecommendationBloc;

  const errorMessage = 'Error message';

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
    movieRecommendationBloc = MockMovieRecommendationBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (context) => movieDetailBloc,
        ),
        BlocProvider<MovieRecommendationBloc>(
          create: (context) => movieRecommendationBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

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
              const MovieDetailPage(
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
              const MovieDetailPage(
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
              GetAsyncDataLoadedState<MovieDetail>(data: testMovieDetail),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            movieRecommendationBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<Movie>>(data: const []),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          await tester.pumpWidget(
            makeTestableWidget(
              MovieDetailPage(
                id: testMovieDetail.id,
              ),
            ),
          );

          await tester.pump();

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
            find.text(
              testMovieDetail.overview,
            ),
            findsOneWidget,
          );
        },
      );
    },
  );

  group(
    'Recommendation data test',
    () {
      testWidgets(
        'Page should show error message when fail to load recommendation',
        (WidgetTester tester) async {
          whenListen(
            movieDetailBloc,
            Stream.value(
              GetAsyncDataLoadedState<MovieDetail>(data: testMovieDetail),
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
              MovieDetailPage(
                id: testMovieDetail.id,
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
              GetAsyncDataLoadedState<MovieDetail>(data: testMovieDetail),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          whenListen(
            movieRecommendationBloc,
            Stream.value(
              GetAsyncDataLoadedState<List<Movie>>(data: testMovieList),
            ),
            initialState: GetAsyncDataInitialState(),
          );
          await tester.pumpWidget(
            makeTestableWidget(
              MovieDetailPage(
                id: testMovieDetail.id,
              ),
            ),
          );

          await tester.pump();

          /// All of the data displayed should be correct
          expect(
            find.byKey(
              Key(
                '$movieRecommendationItemKey-${testMovieList.first.id}',
              ),
            ),
            findsOneWidget,
          );
        },
      );
    },
  );
}
