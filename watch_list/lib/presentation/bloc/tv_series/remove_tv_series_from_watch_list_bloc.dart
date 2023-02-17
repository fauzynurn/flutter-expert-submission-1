import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/use_cases/remove_tv_series_watch_list.dart';
import '../remove_content_from_watch_list_bloc.dart';

class RemoveTvSeriesFromWatchListBloc
    extends RemoveContentFromWatchListBloc<TvSeriesDetail> {
  final RemoveTvSeriesWatchList removeTvSeriesWatchList;
  RemoveTvSeriesFromWatchListBloc({
    required this.removeTvSeriesWatchList,
  });

  @override
  Future<Either<Failure, String>> removeFromWatchList(
      TvSeriesDetail content) async {
    return await removeTvSeriesWatchList.execute(
      content,
    );
  }
}
