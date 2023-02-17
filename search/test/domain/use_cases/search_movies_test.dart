import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/use_cases/search_movie.dart';
import 'package:core/helper/test_helper.mocks.dart';

void main() {
  late SearchMovie useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = SearchMovie(mockMovieRepository);
  });

  final tMovies = <Movie>[];
  const tQuery = 'Spiderman';

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.searchMovies(tQuery),
    ).thenAnswer(
      (_) async => Right(tMovies),
    );
    // act
    final result = await useCase.execute(tQuery);
    // assert
    expect(
      result,
      Right(tMovies),
    );
  });
}
