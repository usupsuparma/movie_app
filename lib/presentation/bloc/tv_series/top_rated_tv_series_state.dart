import 'package:equatable/equatable.dart';
import 'package:g/domain/entities/tv_series.dart';

abstract class TopRatedTvSeriesState extends Equatable {
  const TopRatedTvSeriesState();
  @override
  List<Object?> get props => [];
}

class TopRatedTvSeriesEmpty extends TopRatedTvSeriesState {}

class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {}

class TopRatedTvSeriesError extends TopRatedTvSeriesState {
  final String message;
  const TopRatedTvSeriesError(this.message);
  @override
  List<Object?> get props => [message];
}

class TopRatedTvSeriesLoaded extends TopRatedTvSeriesState {
  final List<TvSeries> tvSeries;
  const TopRatedTvSeriesLoaded(this.tvSeries);
  @override
  List<Object?> get props => [tvSeries];
}
