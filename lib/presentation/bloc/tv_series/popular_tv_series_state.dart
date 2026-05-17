import 'package:equatable/equatable.dart';
import 'package:g/domain/entities/tv_series.dart';

abstract class PopularTvSeriesState extends Equatable {
  const PopularTvSeriesState();
  @override
  List<Object?> get props => [];
}

class PopularTvSeriesEmpty extends PopularTvSeriesState {}
class PopularTvSeriesLoading extends PopularTvSeriesState {}

class PopularTvSeriesError extends PopularTvSeriesState {
  final String message;
  const PopularTvSeriesError(this.message);
  @override
  List<Object?> get props => [message];
}

class PopularTvSeriesLoaded extends PopularTvSeriesState {
  final List<TvSeries> tvSeries;
  const PopularTvSeriesLoaded(this.tvSeries);
  @override
  List<Object?> get props => [tvSeries];
}
