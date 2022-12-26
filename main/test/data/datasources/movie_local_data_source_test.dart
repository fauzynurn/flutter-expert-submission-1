import 'package:core/common/exception.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:ditonton/data/data_sources/movie_local_data_source_impl.dart';
import 'package:ditonton/data/data_sources/tv_series_local_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl movieDataSource;
  late TvSeriesLocalDataSourceImpl tvSeriesDataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    movieDataSource = MovieLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
    tvSeriesDataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('save watchlist', () {
    test(
      'should return success message when insert movie to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(
            movie: testMovieTable,
          ),
        ).thenAnswer((_) async => 1);
        // act
        final result = await movieDataSource.insertWatchlist(testMovieTable);
        // assert
        expect(
          result,
          'Added to Watchlist',
        );
      },
    );

    test(
      'should return success message when insert tv series to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(
            tvSeries: testTvSeriesTable,
          ),
        ).thenAnswer(
          (_) async => 1,
        );
        // act
        final result = await tvSeriesDataSource.insertWatchlist(
          testTvSeriesTable,
        );
        // assert
        expect(
          result,
          'Added to Watchlist',
        );
      },
    );

    test(
      'should throw DatabaseException when insert movie to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(
            movie: testMovieTable,
          ),
        ).thenThrow(Exception());
        // act
        final call = movieDataSource.insertWatchlist(testMovieTable);
        // assert
        expect(
            () => call,
            throwsA(
              isA<DatabaseException>(),
            ));
      },
    );

    test(
      'should throw DatabaseException when insert TV series to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(
            tvSeries: testTvSeriesTable,
          ),
        ).thenThrow(Exception());
        // act
        final call = tvSeriesDataSource.insertWatchlist(
          testTvSeriesTable,
        );
        // assert
        expect(
            () => call,
            throwsA(
              isA<DatabaseException>(),
            ));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove movie from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(
            movie: testMovieTable,
          ),
        ).thenAnswer((_) async => 1);
        // act
        final result = await movieDataSource.removeWatchlist(testMovieTable);
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should return success message when remove TV series from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(
            tvSeries: testTvSeriesTable,
          ),
        ).thenAnswer((_) async => 1);
        // act
        final result = await tvSeriesDataSource.removeWatchlist(
          testTvSeriesTable,
        );
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove movie from database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.removeWatchlist(movie: testMovieTable))
            .thenThrow(Exception());
        // act
        final call = movieDataSource.removeWatchlist(testMovieTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );

    test(
      'should throw DatabaseException when remove TV series from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(
            tvSeries: testTvSeriesTable,
          ),
        ).thenThrow(Exception());
        // act
        final call = tvSeriesDataSource.removeWatchlist(
          testTvSeriesTable,
        );
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get Movie Detail By Id', () {
    final tId = 1;

    test(
      'should return Movie Detail Table when data is found',
      () async {
        // arrange
        when(mockDatabaseHelper.getWatchItemById(tId))
            .thenAnswer((_) async => testMovieMap);
        // act
        final result = await movieDataSource.getMovieById(tId);
        // assert
        expect(result, testMovieTable);
      },
    );

    test(
      'should return TV series Detail Table when data is found',
      () async {
        // arrange
        when(
          mockDatabaseHelper.getWatchItemById(
            tId,
          ),
        ).thenAnswer(
          (_) async => testTvSeriesMap,
        );
        // act
        final result = await tvSeriesDataSource.getTvSeriesById(tId);
        // assert
        expect(
          result,
          testTvSeriesTable,
        );
      },
    );

    test(
      'should return null when movie data is not found',
      () async {
        // arrange
        when(mockDatabaseHelper.getWatchItemById(tId))
            .thenAnswer((_) async => null);
        // act
        final result = await movieDataSource.getMovieById(tId);
        // assert
        expect(result, null);
      },
    );

    test(
      'should return null when TV series data is not found',
      () async {
        // arrange
        when(
          mockDatabaseHelper.getWatchItemById(
            tId,
          ),
        ).thenAnswer((_) async => null);
        // act
        final result = await tvSeriesDataSource.getTvSeriesById(tId);
        // assert
        expect(result, null);
      },
    );
  });

  group(
    'get watchlist',
    () {
      test(
        'should return list of MovieTable from database',
        () async {
          // arrange
          when(
            mockDatabaseHelper.getWatchlist(
              FilterType.movies,
            ),
          ).thenAnswer((_) async => [testMovieMap]);
          // act
          final result = await movieDataSource.getWatchlistMovies();
          // assert
          expect(result, [testMovieTable]);
        },
      );

      test(
        'should return list of TvSeriesTable from database',
        () async {
          // arrange
          when(
            mockDatabaseHelper.getWatchlist(
              FilterType.tvSeries,
            ),
          ).thenAnswer(
            (_) async => [
              testTvSeriesMap,
            ],
          );
          // act
          final result = await tvSeriesDataSource.getWatchlistTvSeries();
          // assert
          expect(
            result,
            [
              testTvSeriesTable,
            ],
          );
        },
      );
    },
  );
}
