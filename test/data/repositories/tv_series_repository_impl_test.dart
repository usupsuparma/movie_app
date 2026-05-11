import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/exception.dart';
import 'package:g/common/failure.dart';
import 'package:g/data/datasources/tv_series_local_data_source.dart';
import 'package:g/data/datasources/tv_series_remote_data_source.dart';
import 'package:g/data/models/tv_series_detail_model.dart';
import 'package:g/data/models/tv_series_model.dart';
import 'package:g/data/models/tv_series_table.dart';
import 'package:g/data/repositories/tv_series_repository_impl.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeTvSeriesRemoteDataSource implements TvSeriesRemoteDataSource {
  List<TvSeriesModel>? onTheAirResult;
  Object? onTheAirError;
  List<TvSeriesModel>? popularResult;
  Object? popularError;
  List<TvSeriesModel>? topRatedResult;
  Object? topRatedError;
  TvSeriesDetailResponse? detailResult;
  Object? detailError;
  List<TvSeriesModel>? recommendationResult;
  Object? recommendationError;
  List<TvSeriesModel>? searchResult;
  Object? searchError;

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
    if (topRatedError != null) throw topRatedError!;
    return topRatedResult ?? [];
  }

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    if (detailError != null) throw detailError!;
    return detailResult!;
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    if (recommendationError != null) throw recommendationError!;
    return recommendationResult ?? [];
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    if (searchError != null) throw searchError!;
    return searchResult ?? [];
  }
}

class FakeTvSeriesLocalDataSource implements TvSeriesLocalDataSource {
  String insertResult = 'Added to Watchlist';
  Object? insertError;
  String removeResult = 'Removed from Watchlist';
  Object? removeError;
  TvSeriesTable? byIdResult;
  List<TvSeriesTable> watchlistResult = [];

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    if (insertError != null) throw insertError!;
    return insertResult;
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async {
    if (removeError != null) throw removeError!;
    return removeResult;
  }

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
    'getPopularTvSeries should return remote data when successful',
    () async {
      mockRemoteDataSource.popularResult = tTvSeriesModelList;

      final result = await repository.getPopularTvSeries();

      result.fold(
        (failure) => fail('Expected Right, got Left($failure)'),
        (tvSeries) => expect(tvSeries, tTvSeriesList),
      );
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

  test(
    'getPopularTvSeries should return server failure when remote throws',
    () async {
      mockRemoteDataSource.popularError = ServerException();

      final result = await repository.getPopularTvSeries();

      expect(result, Left(ServerFailure('')));
    },
  );

  test(
    'getTopRatedTvSeries should return remote data when successful',
    () async {
      mockRemoteDataSource.topRatedResult = tTvSeriesModelList;

      final result = await repository.getTopRatedTvSeries();

      result.fold(
        (failure) => fail('Expected Right, got Left($failure)'),
        (tvSeries) => expect(tvSeries, tTvSeriesList),
      );
    },
  );

  test(
    'getTopRatedTvSeries should return connection failure on SocketException',
    () async {
      mockRemoteDataSource.topRatedError = const SocketException(
        'Failed to connect to the network',
      );

      final result = await repository.getTopRatedTvSeries();

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
    'getTvSeriesDetail should return server failure when remote throws',
    () async {
      mockRemoteDataSource.detailError = ServerException();

      final result = await repository.getTvSeriesDetail(1);

      expect(result, Left(ServerFailure('')));
    },
  );

  test(
    'getTvSeriesDetail should return connection failure on SocketException',
    () async {
      mockRemoteDataSource.detailError = const SocketException(
        'Failed to connect to the network',
      );

      final result = await repository.getTvSeriesDetail(1);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    },
  );

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

  test(
    'getTvSeriesRecommendations should return server failure when remote throws',
    () async {
      mockRemoteDataSource.recommendationError = ServerException();

      final result = await repository.getTvSeriesRecommendations(1);

      expect(result, Left(ServerFailure('')));
    },
  );

  test(
    'getTvSeriesRecommendations should return connection failure on SocketException',
    () async {
      mockRemoteDataSource.recommendationError = const SocketException(
        'Failed to connect to the network',
      );

      final result = await repository.getTvSeriesRecommendations(1);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
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

  test(
    'searchTvSeries should return server failure when remote throws',
    () async {
      mockRemoteDataSource.searchError = ServerException();

      final result = await repository.searchTvSeries('query');

      expect(result, Left(ServerFailure('')));
    },
  );

  test(
    'searchTvSeries should return connection failure on SocketException',
    () async {
      mockRemoteDataSource.searchError = const SocketException(
        'Failed to connect to the network',
      );

      final result = await repository.searchTvSeries('query');

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    },
  );

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

  test('removeWatchlistTvSeries should return success message', () async {
    mockLocalDataSource.removeResult = 'Removed from Watchlist';

    final result = await repository.removeWatchlistTvSeries(tTvSeriesDetail);

    expect(result, const Right('Removed from Watchlist'));
  });

  test(
    'removeWatchlistTvSeries should return database failure when local throws',
    () async {
      mockLocalDataSource.removeError = DatabaseException('Failed');

      final result = await repository.removeWatchlistTvSeries(tTvSeriesDetail);

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

  test(
    'isAddedToWatchlistTvSeries should return false when item is missing',
    () async {
      final result = await repository.isAddedToWatchlistTvSeries(1);

      expect(result, false);
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
