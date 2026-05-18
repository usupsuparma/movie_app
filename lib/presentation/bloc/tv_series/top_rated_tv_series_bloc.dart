import 'package:bloc/bloc.dart';
import 'package:movie_app/domain/usecases/get_top_rated_tv_series.dart';

import 'top_rated_tv_series_event.dart';
import 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc({required this.getTopRatedTvSeries})
    : super(TopRatedTvSeriesEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TopRatedTvSeriesLoading());
      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) => emit(TopRatedTvSeriesError(failure.message)),
        (data) => emit(TopRatedTvSeriesLoaded(data)),
      );
    });
  }
}
