import 'package:flutter/foundation.dart';
import 'package:g/common/state_enum.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/usecases/get_watchlist_tv_series.dart';

class WatchlistTvSeriesNotifier extends ChangeNotifier {
  WatchlistTvSeriesNotifier({required this.getWatchlistTvSeries});

  final GetWatchlistTvSeries getWatchlistTvSeries;

  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvSeries = data;
        notifyListeners();
      },
    );
  }
}
