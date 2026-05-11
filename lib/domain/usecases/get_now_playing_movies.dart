import 'package:dartz/dartz.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/domain/repositories/movie_repository.dart';
import 'package:g/common/failure.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}

