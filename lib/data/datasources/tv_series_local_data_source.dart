import 'package:g/common/exception.dart';
import 'package:g/data/datasources/db/database_helper.dart';
import 'package:g/data/models/tv_series_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlist(TvSeriesTable tvSeries);
  Future<String> removeWatchlist(TvSeriesTable tvSeries);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTvSeries();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.insertWatchlist(tvSeries.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.removeWatchlist(tvSeries.id, tvSeries.mediaType);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getWatchlistById(id, TvSeriesTable.tvMediaType);
    if (result != null) {
      return TvSeriesTable.fromMap(result);
    }
    return null;
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result =
        await databaseHelper.getWatchlistByMediaType(TvSeriesTable.tvMediaType);
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }
}
