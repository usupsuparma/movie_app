import 'package:flutter/foundation.dart';
import 'package:g/common/state_enum.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/entities/tv_series_detail.dart';
import 'package:g/domain/usecases/get_tv_series_detail.dart';
import 'package:g/domain/usecases/get_tv_series_recommendations.dart';
import 'package:g/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:g/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:g/domain/usecases/save_watchlist_tv_series.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  });

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  late TvSeriesDetail _tvSeries;
  TvSeriesDetail get tvSeries => _tvSeries;

  RequestState _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<TvSeries> _recommendations = [];
  List<TvSeries> get recommendations => _recommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _tvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (detail) {
        _recommendationState = RequestState.Loading;
        _tvSeries = detail;
        notifyListeners();

        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (data) {
            _recommendationState = RequestState.Loaded;
            _recommendations = data;
          },
        );

        _tvSeriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> addWatchlist(TvSeriesDetail tvSeries) async {
    final result = await saveWatchlistTvSeries.execute(tvSeries);
    result.fold(
      (failure) => _watchlistMessage = failure.message,
      (message) => _watchlistMessage = message,
    );
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> removeFromWatchlist(TvSeriesDetail tvSeries) async {
    final result = await removeWatchlistTvSeries.execute(tvSeries);
    result.fold(
      (failure) => _watchlistMessage = failure.message,
      (message) => _watchlistMessage = message,
    );
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistStatusTvSeries.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
