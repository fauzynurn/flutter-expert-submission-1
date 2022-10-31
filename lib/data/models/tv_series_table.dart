import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';

class TvSeriesTable extends Equatable {
  final int id;
  final String type;
  final String? name;
  final String? posterPath;
  final String? overview;

  TvSeriesTable({
    required this.id,
    required this.type,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) => TvSeriesTable(
        id: tvSeries.id,
        type: 'tv_series',
        name: tvSeries.name,
        posterPath: tvSeries.posterPath,
        overview: tvSeries.overview,
      );

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
        id: map['id'],
        type: 'tv_series',
        name: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'tv_series',
        'title': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  TvSeries toEntity() => TvSeries.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: name,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        posterPath,
        overview,
      ];
}
