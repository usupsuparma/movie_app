import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/common/state_enum.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/entities/tv_series_detail.dart';
import 'package:g/domain/repositories/tv_series_repository.dart';
import 'package:g/domain/usecases/get_tv_series_detail.dart';
import 'package:g/domain/usecases/get_tv_series_recommendations.dart';
import 'package:g/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:g/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:g/domain/usecases/save_watchlist_tv_series.dart';
import 'package:g/presentation/provider/tv_series_detail_notifier.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeGetTvSeriesDetail implements GetTvSeriesDetail {
  Future<Either<Failure, TvSeriesDetail>> Function(int id)? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, TvSeriesDetail>> execute(int id) => handler!(id);
}

class FakeGetTvSeriesRecommendations implements GetTvSeriesRecommendations {
  Future<Either<Failure, List<TvSeries>>> Function(int id)? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<TvSeries>>> execute(int id) => handler!(id);
}

class FakeGetWatchlistStatusTvSeries implements GetWatchlistStatusTvSeries {
  Future<bool> Function(int id)? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<bool> execute(int id) => handler!(id);
}

class FakeSaveWatchlistTvSeries implements SaveWatchlistTvSeries {
  Future<Either<Failure, String>> Function(TvSeriesDetail tvSeries)? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) =>
      handler!(tvSeries);
}

class FakeRemoveWatchlistTvSeries implements RemoveWatchlistTvSeries {
  Future<Either<Failure, String>> Function(TvSeriesDetail tvSeries)? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) =>
      handler!(tvSeries);
}

void main() {
  late TvSeriesDetailNotifier notifier;
  late FakeGetTvSeriesDetail mockGetTvSeriesDetail;
  late FakeGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late FakeGetWatchlistStatusTvSeries mockGetWatchlistStatusTvSeries;
  late FakeSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late FakeRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetTvSeriesDetail = FakeGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = FakeGetTvSeriesRecommendations();
    mockGetWatchlistStatusTvSeries = FakeGetWatchlistStatusTvSeries();
    mockSaveWatchlistTvSeries = FakeSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = FakeRemoveWatchlistTvSeries();

    notifier = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchlistStatusTvSeries: mockGetWatchlistStatusTvSeries,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
    );
  });

  test(
    'fetchTvSeriesDetail should populate detail and recommendations',
    () async {
      mockGetTvSeriesDetail.handler = (id) async => Right(tTvSeriesDetail);
      mockGetTvSeriesRecommendations.handler = (id) async =>
          Right(tTvSeriesList);

      await notifier.fetchTvSeriesDetail(1);

      expect(notifier.tvSeriesState, RequestState.Loaded);
      expect(notifier.recommendationState, RequestState.Loaded);
      expect(notifier.tvSeries, tTvSeriesDetail);
      expect(notifier.recommendations, tTvSeriesList);
    },
  );

  test('fetchTvSeriesDetail should set error state on failure', () async {
    mockGetTvSeriesDetail.handler = (id) async => Left(ServerFailure('Failed'));
    mockGetTvSeriesRecommendations.handler = (id) async => Right(tTvSeriesList);

    await notifier.fetchTvSeriesDetail(1);

    expect(notifier.tvSeriesState, RequestState.Error);
    expect(notifier.message, 'Failed');
  });

  test(
    'fetchTvSeriesDetail should set recommendation error state on failure',
    () async {
      mockGetTvSeriesDetail.handler = (id) async => Right(tTvSeriesDetail);
      mockGetTvSeriesRecommendations.handler = (id) async =>
          Left(ServerFailure('Recommendation failed'));

      await notifier.fetchTvSeriesDetail(1);

      expect(notifier.tvSeriesState, RequestState.Loaded);
      expect(notifier.recommendationState, RequestState.Error);
      expect(notifier.message, 'Recommendation failed');
    },
  );

  test('addWatchlist should update watchlist message and status', () async {
    mockSaveWatchlistTvSeries.handler = (tvSeries) async =>
        const Right('Added to Watchlist');
    mockGetWatchlistStatusTvSeries.handler = (id) async => true;

    await notifier.addWatchlist(tTvSeriesDetail);

    expect(notifier.watchlistMessage, 'Added to Watchlist');
    expect(notifier.isAddedToWatchlist, true);
  });

  test('addWatchlist should update watchlist message on failure', () async {
    mockSaveWatchlistTvSeries.handler = (tvSeries) async =>
        Left(DatabaseFailure('Failed'));
    mockGetWatchlistStatusTvSeries.handler = (id) async => false;

    await notifier.addWatchlist(tTvSeriesDetail);

    expect(notifier.watchlistMessage, 'Failed');
    expect(notifier.isAddedToWatchlist, false);
  });

  test(
    'removeFromWatchlist should update watchlist message and status',
    () async {
      mockRemoveWatchlistTvSeries.handler = (tvSeries) async =>
          const Right('Removed from Watchlist');
      mockGetWatchlistStatusTvSeries.handler = (id) async => false;

      await notifier.removeFromWatchlist(tTvSeriesDetail);

      expect(notifier.watchlistMessage, 'Removed from Watchlist');
      expect(notifier.isAddedToWatchlist, false);
    },
  );

  test(
    'removeFromWatchlist should update watchlist message on failure',
    () async {
      mockRemoveWatchlistTvSeries.handler = (tvSeries) async =>
          Left(DatabaseFailure('Remove failed'));
      mockGetWatchlistStatusTvSeries.handler = (id) async => true;

      await notifier.removeFromWatchlist(tTvSeriesDetail);

      expect(notifier.watchlistMessage, 'Remove failed');
      expect(notifier.isAddedToWatchlist, true);
    },
  );
}
