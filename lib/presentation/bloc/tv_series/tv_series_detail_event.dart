import 'package:equatable/equatable.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;
  const FetchTvSeriesDetail(this.id);
  @override
  List<Object> get props => [id];
}

class AddTvSeriesWatchlist extends TvSeriesDetailEvent {
  final dynamic tvSeries;
  const AddTvSeriesWatchlist(this.tvSeries);
  @override
  List<Object> get props => [tvSeries];
}

class RemoveTvSeriesWatchlist extends TvSeriesDetailEvent {
  final dynamic tvSeries;
  const RemoveTvSeriesWatchlist(this.tvSeries);
  @override
  List<Object> get props => [tvSeries];
}
