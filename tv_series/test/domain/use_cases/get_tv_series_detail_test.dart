import 'package:core/helper/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/use_cases/get_tv_series_detail.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetTvSeriesDetail useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetTvSeriesDetail(mockTvSeriesRepository);
  });

  const tId = 1;

  test(
    'should get tv series detail from the repository',
    () async {
      // arrange
      when(
        mockTvSeriesRepository.getTvSeriesDetail(tId),
      ).thenAnswer(
        (_) async => Right(
          testTvSeriesDetail,
        ),
      );
      // act
      final result = await useCase.execute(tId);
      // assert
      expect(
        result,
        Right(testTvSeriesDetail),
      );
    },
  );
}
