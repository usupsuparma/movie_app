import 'package:flutter/material.dart';
import 'package:movie_app/common/state_enum.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:movie_app/domain/usecases/get_popular_tv_series.dart';
import 'package:movie_app/domain/usecases/get_top_rated_tv_series.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  TvSeriesListNotifier({
    required this.getOnTheAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  });

  final GetOnTheAirTvSeries getOnTheAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  var _onTheAirTvSeries = <TvSeries>[];
  List<TvSeries> get onTheAirTvSeries => _onTheAirTvSeries;

  RequestState _onTheAirState = RequestState.empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popularTvSeries = <TvSeries>[];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularState = RequestState.empty;
  RequestState get popularState => _popularState;

  var _topRatedTvSeries = <TvSeries>[];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedState = RequestState.empty;
  RequestState get topRatedState => _topRatedState;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnTheAirTvSeries() async {
    _onTheAirState = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTvSeries.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _onTheAirState = RequestState.loaded;
        _onTheAirTvSeries = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvSeries() async {
    _popularState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _popularState = RequestState.loaded;
        _popularTvSeries = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _topRatedState = RequestState.loaded;
        _topRatedTvSeries = data;
        notifyListeners();
      },
    );
  }
}
