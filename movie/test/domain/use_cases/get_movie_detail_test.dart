import 'package:core/helper/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/use_cases/get_movie_detail.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetMovieDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetail(mockMovieRepository);
  });

  const tId = 1;

  test('should get movie detail from the repository', () async {
    // arrange
    when(mockMovieRepository.getMovieDetail(tId)).thenAnswer(
      (_) async => const Right(testMovieDetail),
    );
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(
      result,
      const Right(testMovieDetail),
    );
  });
}
