import 'package:dartz/dartz.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/repositories/tv_series_repository.dart';

class GetPopularTvSeries {
  final TvSeriesRepository repository;

  GetPopularTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getPopularTvSeries();
  }
}
