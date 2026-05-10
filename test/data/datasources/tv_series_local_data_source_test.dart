import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/exception.dart';
import 'package:movie_app/data/datasources/db/database_helper.dart';
import 'package:movie_app/data/datasources/tv_series_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeDatabaseHelper implements DatabaseHelper {
  int insertResult = 1;
  Object? insertError;
  Map<String, dynamic>? byIdResult;
  List<Map<String, dynamic>> listResult = [];

  @override
  Future<int> insertWatchlist(Map<String, dynamic> data) async {
    if (insertError != null) {
      throw insertError!;
    }
    return insertResult;
  }

  @override
  Future<Map<String, dynamic>?> getWatchlistById(
    int id,
    String mediaType,
  ) async => byIdResult;

  @override
  Future<List<Map<String, dynamic>>> getWatchlistByMediaType(
    String mediaType,
  ) async => listResult;

  @override
  Future<int> removeWatchlist(int id, String mediaType) async => 1;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late FakeDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = FakeDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  test('insertWatchlist should return success message', () async {
    mockDatabaseHelper.insertResult = 1;

    final result = await dataSource.insertWatchlist(tTvSeriesTable);

    expect(result, 'Added to Watchlist');
  });

  test(
    'insertWatchlist should throw DatabaseException when insert fails',
    () async {
      mockDatabaseHelper.insertError = Exception('Failed');

      expect(
        () => dataSource.insertWatchlist(tTvSeriesTable),
        throwsA(isA<DatabaseException>()),
      );
    },
  );

  test('getTvSeriesById should return TvSeriesTable when data found', () async {
    mockDatabaseHelper.byIdResult = tTvSeriesMap;

    final result = await dataSource.getTvSeriesById(1);

    expect(result, tTvSeriesTable);
  });

  test('getWatchlistTvSeries should return list of TvSeriesTable', () async {
    mockDatabaseHelper.listResult = [tTvSeriesMap];

    final result = await dataSource.getWatchlistTvSeries();

    expect(result, [tTvSeriesTable]);
  });
}
