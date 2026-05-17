import 'package:bloc/bloc.dart';
import 'package:g/domain/usecases/search_tv_series.dart';

import 'tv_series_search_event.dart';
import 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc({required this.searchTvSeries})
    : super(TvSeriesSearchEmpty()) {
    on<SearchTvSeriesEvent>((event, emit) async {
      emit(TvSeriesSearchLoading());
      final result = await searchTvSeries.execute(event.query);
      result.fold(
        (failure) => emit(TvSeriesSearchError(failure.message)),
        (data) => emit(TvSeriesSearchLoaded(data)),
      );
    });
  }
}
