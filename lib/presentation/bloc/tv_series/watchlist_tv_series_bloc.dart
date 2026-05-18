import 'package:bloc/bloc.dart';
import 'package:movie_app/domain/usecases/get_watchlist_tv_series.dart';

import 'watchlist_tv_series_event.dart';
import 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc({required this.getWatchlistTvSeries})
    : super(WatchlistTvSeriesEmpty()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(WatchlistTvSeriesLoading());
      final result = await getWatchlistTvSeries.execute();
      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (data) => emit(WatchlistTvSeriesLoaded(data)),
      );
    });
  }
}
