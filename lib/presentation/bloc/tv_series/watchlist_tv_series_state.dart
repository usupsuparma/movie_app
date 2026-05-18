import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/entities/tv_series.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();
  @override
  List<Object?> get props => [];
}

class WatchlistTvSeriesEmpty extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;
  const WatchlistTvSeriesError(this.message);
  @override
  List<Object?> get props => [message];
}

class WatchlistTvSeriesLoaded extends WatchlistTvSeriesState {
  final List<TvSeries> tvSeries;
  const WatchlistTvSeriesLoaded(this.tvSeries);
  @override
  List<Object?> get props => [tvSeries];
}
