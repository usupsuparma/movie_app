import 'package:bloc/bloc.dart';
import 'package:g/domain/usecases/get_popular_tv_series.dart';

import 'popular_tv_series_event.dart';
import 'popular_tv_series_state.dart';

class PopularTvSeriesBloc extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc({required this.getPopularTvSeries}) : super(PopularTvSeriesEmpty()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(PopularTvSeriesLoading());
      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(PopularTvSeriesError(failure.message)),
        (data) => emit(PopularTvSeriesLoaded(data)),
      );
    });
  }
}
