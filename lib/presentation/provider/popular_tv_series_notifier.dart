import 'package:flutter/foundation.dart';
import 'package:movie_app/common/state_enum.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/usecases/get_popular_tv_series.dart';

class PopularTvSeriesNotifier extends ChangeNotifier {
  PopularTvSeriesNotifier(this.getPopularTvSeries);

  final GetPopularTvSeries getPopularTvSeries;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TvSeries> _tvSeries = [];
  List<TvSeries> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvSeries() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (data) {
        _tvSeries = data;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
