import 'package:dartz/dartz.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/domain/repositories/movie_repository.dart';
import 'package:g/common/failure.dart';

class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
