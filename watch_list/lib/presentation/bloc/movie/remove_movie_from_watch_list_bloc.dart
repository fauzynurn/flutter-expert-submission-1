import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:watch_list/domain/use_cases/remove_movie_watch_list.dart';

import '../remove_content_from_watch_list_bloc.dart';

class RemoveMovieFromWatchListBloc
    extends RemoveContentFromWatchListBloc<MovieDetail> {
  final RemoveMovieWatchList removeMovieWatchList;
  RemoveMovieFromWatchListBloc({
    required this.removeMovieWatchList,
  });

  @override
  Future<Either<Failure, String>> removeFromWatchList(
      MovieDetail content) async {
    return await removeMovieWatchList.execute(
      content,
    );
  }
}
