import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final genreModel = GenreModel(
    id: 1,
    name: 'genre-1',
  );
  final genreModelJson = {
    'id': 1,
    'name': 'genre-1',
  };
  final genre = Genre(
    id: 1,
    name: 'genre-1',
  );
  test(
    'should return GenreModel from json format',
    () {
      final result = GenreModel.fromJson(
        genreModelJson,
      );
      expect(
        result,
        genreModel,
      );
    },
  );

  test(
    'should return json format from GenreModel',
    () {
      final result = genreModel.toJson();
      expect(
        result,
        genreModelJson,
      );
    },
  );

  test(
    'should return Genre from GenreModel',
    () {
      final result = genreModel.toEntity();
      expect(
        result,
        genre,
      );
    },
  );
}
