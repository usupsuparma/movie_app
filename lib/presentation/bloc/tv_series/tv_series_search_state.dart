import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/entities/tv_series.dart';

abstract class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();
  @override
  List<Object?> get props => [];
}

class TvSeriesSearchEmpty extends TvSeriesSearchState {}

class TvSeriesSearchLoading extends TvSeriesSearchState {}

class TvSeriesSearchError extends TvSeriesSearchState {
  final String message;
  const TvSeriesSearchError(this.message);
  @override
  List<Object?> get props => [message];
}

class TvSeriesSearchLoaded extends TvSeriesSearchState {
  final List<TvSeries> results;
  const TvSeriesSearchLoaded(this.results);
  @override
  List<Object?> get props => [results];
}
