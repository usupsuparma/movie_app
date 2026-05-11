import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/common/state_enum.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/repositories/tv_series_repository.dart';
import 'package:g/domain/usecases/get_watchlist_tv_series.dart';
import 'package:g/presentation/provider/watchlist_tv_series_notifier.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeGetWatchlistTvSeries implements GetWatchlistTvSeries {
  Future<Either<Failure, List<TvSeries>>> Function()? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<TvSeries>>> execute() => handler!();
}

void main() {
  late WatchlistTvSeriesNotifier notifier;
  late FakeGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = FakeGetWatchlistTvSeries();
    notifier = WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  test('fetchWatchlistTvSeries should return data when successful', () async {
    mockGetWatchlistTvSeries.handler = () async => Right(tTvSeriesList);

    await notifier.fetchWatchlistTvSeries();

    expect(notifier.watchlistState, RequestState.Loaded);
    expect(notifier.watchlistTvSeries, tTvSeriesList);
  });

  test('fetchWatchlistTvSeries should set error on failure', () async {
    mockGetWatchlistTvSeries.handler = () async =>
        Left(ServerFailure('Failed'));

    await notifier.fetchWatchlistTvSeries();

    expect(notifier.watchlistState, RequestState.Error);
    expect(notifier.message, 'Failed');
  });
}
