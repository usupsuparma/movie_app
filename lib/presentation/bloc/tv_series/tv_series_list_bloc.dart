import 'package:bloc/bloc.dart';
import 'package:movie_app/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:movie_app/domain/usecases/get_popular_tv_series.dart';
import 'package:movie_app/domain/usecases/get_top_rated_tv_series.dart';

import 'tv_series_list_event.dart';
import 'tv_series_list_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  final GetOnTheAirTvSeries getOnTheAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvSeriesListBloc({
    required this.getOnTheAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(TvSeriesListEmpty()) {
    on<FetchOnTheAirTvSeries>((event, emit) async {
      emit(TvSeriesListLoading());
      final result = await getOnTheAirTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (data) => emit(TvSeriesListLoaded(data)),
      );
    });

    on<FetchPopularTvSeriesList>((event, emit) async {
      emit(TvSeriesListLoading());
      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (data) => emit(TvSeriesListLoaded(data)),
      );
    });

    on<FetchTopRatedTvSeriesList>((event, emit) async {
      emit(TvSeriesListLoading());
      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (data) => emit(TvSeriesListLoaded(data)),
      );
    });
  }
}
