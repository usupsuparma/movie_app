import 'package:equatable/equatable.dart';
import 'package:g/domain/entities/tv_series.dart';

abstract class TvSeriesListState extends Equatable {
  const TvSeriesListState();
  @override
  List<Object?> get props => [];
}

class TvSeriesListEmpty extends TvSeriesListState {}
class TvSeriesListLoading extends TvSeriesListState {}

class TvSeriesListError extends TvSeriesListState {
  final String message;
  const TvSeriesListError(this.message);
  @override
  List<Object?> get props => [message];
}

class TvSeriesListLoaded extends TvSeriesListState {
  final List<TvSeries> tvSeries;
  const TvSeriesListLoaded(this.tvSeries);
  @override
  List<Object?> get props => [tvSeries];
}
