import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/common/state_enum.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/repositories/tv_series_repository.dart';
import 'package:movie_app/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:movie_app/domain/usecases/get_popular_tv_series.dart';
import 'package:movie_app/domain/usecases/get_top_rated_tv_series.dart';
import 'package:movie_app/presentation/provider/tv_series_list_notifier.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeGetOnTheAirTvSeries implements GetOnTheAirTvSeries {
  Future<Either<Failure, List<TvSeries>>> Function()? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<TvSeries>>> execute() => handler!();
}

class FakeGetPopularTvSeries implements GetPopularTvSeries {
  Future<Either<Failure, List<TvSeries>>> Function()? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<TvSeries>>> execute() => handler!();
}

class FakeGetTopRatedTvSeries implements GetTopRatedTvSeries {
  Future<Either<Failure, List<TvSeries>>> Function()? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<TvSeries>>> execute() => handler!();
}

void main() {
  late TvSeriesListNotifier notifier;
  late FakeGetOnTheAirTvSeries mockGetOnTheAirTvSeries;
  late FakeGetPopularTvSeries mockGetPopularTvSeries;
  late FakeGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = FakeGetOnTheAirTvSeries();
    mockGetPopularTvSeries = FakeGetPopularTvSeries();
    mockGetTopRatedTvSeries = FakeGetTopRatedTvSeries();
    notifier = TvSeriesListNotifier(
      getOnTheAirTvSeries: mockGetOnTheAirTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  test('initial state should be Empty', () {
    expect(notifier.onTheAirState, RequestState.Empty);
    expect(notifier.popularState, RequestState.Empty);
    expect(notifier.topRatedState, RequestState.Empty);
  });

  test('fetchOnTheAirTvSeries should update list when successful', () async {
    mockGetOnTheAirTvSeries.handler = () async => Right(tTvSeriesList);

    await notifier.fetchOnTheAirTvSeries();

    expect(notifier.onTheAirState, RequestState.Loaded);
    expect(notifier.onTheAirTvSeries, tTvSeriesList);
  });

  test('fetchPopularTvSeries should set error state on failure', () async {
    mockGetPopularTvSeries.handler = () async =>
        Left(ServerFailure('Server Failure'));

    await notifier.fetchPopularTvSeries();

    expect(notifier.popularState, RequestState.Error);
    expect(notifier.message, 'Server Failure');
  });

  test('fetchTopRatedTvSeries should update list when successful', () async {
    mockGetTopRatedTvSeries.handler = () async => Right(tTvSeriesList);

    await notifier.fetchTopRatedTvSeries();

    expect(notifier.topRatedState, RequestState.Loaded);
    expect(notifier.topRatedTvSeries, tTvSeriesList);
  });
}
