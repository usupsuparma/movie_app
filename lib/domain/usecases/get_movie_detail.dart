import 'package:dartz/dartz.dart';
import 'package:g/domain/entities/movie_detail.dart';
import 'package:g/domain/repositories/movie_repository.dart';
import 'package:g/common/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}

