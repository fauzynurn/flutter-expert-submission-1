import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:watch_list/presentation/bloc/add_content_to_watch_list_bloc.dart';

import '../../../domain/use_cases/save_tv_series_watch_list.dart';

class AddTvSeriesToWatchListBloc extends AddContentToWatchList<TvSeriesDetail> {
  final SaveTvSeriesWatchList saveTvSeriesWatchList;
  AddTvSeriesToWatchListBloc({
    required this.saveTvSeriesWatchList,
  });

  @override
  Future<Either<Failure, String>> addToWatchlist(TvSeriesDetail content) async {
    return await saveTvSeriesWatchList.execute(
      content,
    );
  }
}
