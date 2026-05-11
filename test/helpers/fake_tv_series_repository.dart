import 'package:dartz/dartz.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/entities/tv_series_detail.dart';
import 'package:g/domain/repositories/tv_series_repository.dart';

class FakeTvSeriesRepository implements TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> Function()? onTheAirHandler;
  Future<Either<Failure, List<TvSeries>>> Function()? popularHandler;
  Future<Either<Failure, List<TvSeries>>> Function()? topRatedHandler;
  Future<Either<Failure, TvSeriesDetail>> Function()? detailHandler;
  Future<Either<Failure, List<TvSeries>>> Function()? recommendationsHandler;
  Future<Either<Failure, List<TvSeries>>> Function(String query)? searchHandler;
  Future<Either<Failure, String>> Function(TvSeriesDetail tvSeries)?
      saveWatchlistHandler;
  Future<Either<Failure, String>> Function(TvSeriesDetail tvSeries)?
      removeWatchlistHandler;
  Future<bool> Function(int id)? watchlistStatusHandler;
  Future<Either<Failure, List<TvSeries>>> Function()? watchlistHandler;

  @override
  Future<Either<Failure, List<TvSeries>>> getOnTheAirTvSeries() {
    return onTheAirHandler!();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() {
    return popularHandler!();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() {
    return topRatedHandler!();
  }

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) {
    return detailHandler!();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id) {
    return recommendationsHandler!();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) {
    return searchHandler!(query);
  }

  @override
  Future<Either<Failure, String>> saveWatchlistTvSeries(
    TvSeriesDetail tvSeries,
  ) {
    return saveWatchlistHandler!(tvSeries);
  }

  @override
  Future<Either<Failure, String>> removeWatchlistTvSeries(
    TvSeriesDetail tvSeries,
  ) {
    return removeWatchlistHandler!(tvSeries);
  }

  @override
  Future<bool> isAddedToWatchlistTvSeries(int id) {
    return watchlistStatusHandler!(id);
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() {
    return watchlistHandler!();
  }
}
