import 'package:ditonton/domain/entities/filter_type.dart';

extension FilterTypeKey on FilterType {
  String get dbKey {
    switch (this) {
      case FilterType.movies:
        return 'movie';
      case FilterType.tvSeries:
        return 'tv_series';
    }
  }
}
