import 'package:dartz/dartz.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
