// Mocks generated by Mockito 5.3.2 from annotations
// in watch_list/test/presentation/bloc/get_watch_list_status_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:core/domain/repositories/movie_repository.dart' as _i2;
import 'package:core/domain/repositories/tv_series_repository.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:watch_list/domain/use_cases/get_movie_watch_list_status.dart'
    as _i4;
import 'package:watch_list/domain/use_cases/get_tv_series_watch_list_status.dart'
    as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeMovieRepository_0 extends _i1.SmartFake
    implements _i2.MovieRepository {
  _FakeMovieRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTvSeriesRepository_1 extends _i1.SmartFake
    implements _i3.TvSeriesRepository {
  _FakeTvSeriesRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetMovieWatchListStatus].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMovieWatchListStatus extends _i1.Mock
    implements _i4.GetMovieWatchListStatus {
  MockGetMovieWatchListStatus() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MovieRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeMovieRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.MovieRepository);
  @override
  _i5.Future<bool> execute(int? id) => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [id],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
}

/// A class which mocks [GetTvSeriesWatchListStatus].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTvSeriesWatchListStatus extends _i1.Mock
    implements _i6.GetTvSeriesWatchListStatus {
  MockGetTvSeriesWatchListStatus() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.TvSeriesRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeTvSeriesRepository_1(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i3.TvSeriesRepository);
  @override
  _i5.Future<bool> execute(int? id) => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [id],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
}
