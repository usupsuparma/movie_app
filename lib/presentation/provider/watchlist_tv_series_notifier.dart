import 'package:flutter/foundation.dart';
import 'package:movie_app/common/state_enum.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/usecases/get_watchlist_tv_series.dart';

class WatchlistTvSeriesNotifier extends ChangeNotifier {
  WatchlistTvSeriesNotifier({required this.getWatchlistTvSeries});

  final GetWatchlistTvSeries getWatchlistTvSeries;

  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _watchlistState = RequestState.loaded;
        _watchlistTvSeries = data;
        notifyListeners();
      },
    );
  }
}
