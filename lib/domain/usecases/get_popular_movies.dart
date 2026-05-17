import 'package:dartz/dartz.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
