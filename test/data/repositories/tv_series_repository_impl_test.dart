import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/exception.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/data/datasources/tv_series_local_data_source.dart';
import 'package:movie_app/data/datasources/tv_series_remote_data_source.dart';
import 'package:movie_app/data/models/tv_series_detail_model.dart';
import 'package:movie_app/data/models/tv_series_model.dart';
import 'package:movie_app/data/models/tv_series_table.dart';
import 'package:movie_app/data/repositories/tv_series_repository_impl.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeTvSeriesRemoteDataSource implements TvSeriesRemoteDataSource {
  List<TvSeriesModel>? onTheAirResult;
  Object? onTheAirError;
  List<TvSeriesModel>? popularResult;
  Object? popularError;
  TvSeriesDetailResponse? detailResult;
  Object? detailError;
  List<TvSeriesModel>? recommendationResult;
  List<TvSeriesModel>? searchResult;

  @override
  Future<List<TvSeriesModel>> getOnTheAirTvSeries() async {
    if (onTheAirError != null) throw onTheAirError!;
    return onTheAirResult ?? [];
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    if (popularError != null) throw popularError!;
    return popularResult ?? [];
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    return popularResult ?? [];
  }

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    if (detailError != null) throw detailError!;
    return detailResult!;
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    return recommendationResult ?? [];
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    return searchResult ?? [];
  }
}

class FakeTvSeriesLocalDataSource implements TvSeriesLocalDataSource {
  String insertResult = 'Added to Watchlist';
  Object? insertError;
  TvSeriesTable? byIdResult;
  List<TvSeriesTable> watchlistResult = [];

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    if (insertError != null) throw insertError!;
    return insertResult;
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async =>
      'Removed from Watchlist';

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async => byIdResult;

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async => watchlistResult;
}

void main() {
  late TvSeriesRepositoryImpl repository;
  late FakeTvSeriesRemoteDataSource mockRemoteDataSource;
  late FakeTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = FakeTvSeriesRemoteDataSource();
    mockLocalDataSource = FakeTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  test(
    'getOnTheAirTvSeries should return remote data when successful',
    () async {
      mockRemoteDataSource.onTheAirResult = tTvSeriesModelList;

      final result = await repository.getOnTheAirTvSeries();

      result.fold(
        (failure) => fail('Expected Right, got Left($failure)'),
        (tvSeries) => expect(tvSeries, tTvSeriesList),
      );
    },
  );

  test(
    'getOnTheAirTvSeries should return server failure when remote throws',
    () async {
      mockRemoteDataSource.onTheAirError = ServerException();

      final result = await repository.getOnTheAirTvSeries();

      expect(result, Left(ServerFailure('')));
    },
  );

  test(
    'getPopularTvSeries should return connection failure on SocketException',
    () async {
      mockRemoteDataSource.popularError = const SocketException(
        'Failed to connect to the network',
      );

      final result = await repository.getPopularTvSeries();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    },
  );

  test('getTvSeriesDetail should return detail data', () async {
    mockRemoteDataSource.detailResult = tTvSeriesDetailResponse;

    final result = await repository.getTvSeriesDetail(1);

    expect(result, Right(tTvSeriesDetailResponse.toEntity()));
  });

  test(
    'getTvSeriesRecommendations should return recommendation list',
    () async {
      mockRemoteDataSource.recommendationResult = tTvSeriesModelList;

      final result = await repository.getTvSeriesRecommendations(1);

      result.fold(
        (failure) => fail('Expected Right, got Left($failure)'),
        (tvSeries) => expect(tvSeries, tTvSeriesList),
      );
    },
  );

  test('searchTvSeries should return search results', () async {
    mockRemoteDataSource.searchResult = tTvSeriesModelList;

    final result = await repository.searchTvSeries('query');

    result.fold(
      (failure) => fail('Expected Right, got Left($failure)'),
      (tvSeries) => expect(tvSeries, tTvSeriesList),
    );
  });

  test('saveWatchlistTvSeries should return success message', () async {
    mockLocalDataSource.insertResult = 'Added to Watchlist';

    final result = await repository.saveWatchlistTvSeries(tTvSeriesDetail);

    expect(result, const Right('Added to Watchlist'));
  });

  test(
    'saveWatchlistTvSeries should return database failure when local throws',
    () async {
      mockLocalDataSource.insertError = DatabaseException('Failed');

      final result = await repository.saveWatchlistTvSeries(tTvSeriesDetail);

      expect(result, Left(DatabaseFailure('Failed')));
    },
  );

  test(
    'isAddedToWatchlistTvSeries should return true when item exists',
    () async {
      mockLocalDataSource.byIdResult = tTvSeriesTable;

      final result = await repository.isAddedToWatchlistTvSeries(1);

      expect(result, true);
    },
  );

  test('getWatchlistTvSeries should return local watchlist data', () async {
    mockLocalDataSource.watchlistResult = [tTvSeriesTable];

    final result = await repository.getWatchlistTvSeries();

    result.fold(
      (failure) => fail('Expected Right, got Left($failure)'),
      (tvSeries) => expect(tvSeries, [tTvSeriesTable.toEntity()]),
    );
  });
}
