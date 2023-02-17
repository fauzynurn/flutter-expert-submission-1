import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/use_cases/get_tv_series_detail.dart';
import 'package:tv_series/domain/use_cases/get_tv_series_recommendations.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/events/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_recommendation_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
])
void main() {
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late TvSeriesRecommendationBloc tvSeriesRecommendationBloc;

  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();

    tvSeriesDetailBloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
    );
    tvSeriesRecommendationBloc = TvSeriesRecommendationBloc(
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
    );
  });

  const tId = 1;

  group(
    'Get TvSeries Detail',
    () {
      blocTest<TvSeriesDetailBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetTvSeriesDetailDataEvent] event is added',
        build: () {
          when(
            mockGetTvSeriesDetail.execute(tId),
          ).thenAnswer(
            (_) async => Right(testTvSeriesDetail),
          );
          return tvSeriesDetailBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesDetailDataEvent(
            id: tId,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: testTvSeriesDetail,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTvSeriesDetail.execute(tId),
          );
        },
      );
      blocTest<TvSeriesDetailBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetTvSeriesDetailDataEvent] event is added',
        build: () {
          when(
            mockGetTvSeriesDetail.execute(tId),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return tvSeriesDetailBloc;
        },
        act: (bloc) => bloc.add(
          GetTvSeriesDetailDataEvent(
            id: tId,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occurred',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTvSeriesDetail.execute(tId),
          );
        },
      );
    },
  );

  group(
    'Get TvSeries Recommendation',
    () {
      blocTest<TvSeriesRecommendationBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataLoadedState] when [GetRecommendationTvSeriesDataEvent] event is added',
        build: () {
          when(mockGetTvSeriesRecommendations.execute(tId))
              .thenAnswer((_) async => Right(testTvSeriesList));
          return tvSeriesRecommendationBloc;
        },
        act: (bloc) => bloc.add(
          GetRecommendationTvSeriesDataEvent(
            id: tId,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataLoadedState(
            data: testTvSeriesList,
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTvSeriesRecommendations.execute(tId),
          );
        },
      );
      blocTest<TvSeriesRecommendationBloc, GetAsyncDataState>(
        'Should emit [GetAsyncDataLoadingState, GetAsyncDataErrorState] when [GetRecommendationTvSeriesDataEvent] event is added',
        build: () {
          when(
            mockGetTvSeriesRecommendations.execute(tId),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure('A server error occurred'),
            ),
          );
          return tvSeriesRecommendationBloc;
        },
        act: (bloc) => bloc.add(
          GetRecommendationTvSeriesDataEvent(
            id: tId,
          ),
        ),
        expect: () => [
          GetAsyncDataLoadingState(),
          GetAsyncDataErrorState(
            message: 'A server error occurred',
          ),
        ],
        verify: (bloc) {
          verify(
            mockGetTvSeriesRecommendations.execute(tId),
          );
        },
      );
    },
  );
}
