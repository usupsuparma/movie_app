import 'package:equatable/equatable.dart';

abstract class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();
  @override
  List<Object> get props => [];
}

class FetchOnTheAirTvSeries extends TvSeriesListEvent {}

class FetchPopularTvSeriesList extends TvSeriesListEvent {}

class FetchTopRatedTvSeriesList extends TvSeriesListEvent {}
