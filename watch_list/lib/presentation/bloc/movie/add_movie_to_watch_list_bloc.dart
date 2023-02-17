import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:watch_list/domain/use_cases/save_movie_watch_list.dart';
import 'package:watch_list/presentation/bloc/add_content_to_watch_list_bloc.dart';

class AddMovieToWatchListBloc extends AddContentToWatchList<MovieDetail> {
  final SaveMovieWatchList saveMovieWatchList;
  AddMovieToWatchListBloc({
    required this.saveMovieWatchList,
  });

  @override
  Future<Either<Failure, String>> addToWatchlist(MovieDetail content) async {
    return await saveMovieWatchList.execute(
      content,
    );
  }
}
