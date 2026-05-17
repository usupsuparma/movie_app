import 'package:dartz/dartz.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/entities/movie_detail.dart';
import 'package:g/domain/repositories/movie_repository.dart';

class SaveWatchlist {
  final MovieRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
