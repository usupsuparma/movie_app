import 'package:equatable/equatable.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/entities/tv_series_detail.dart';

abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();
  @override
  List<Object?> get props => [];
}

class TvSeriesDetailEmpty extends TvSeriesDetailState {}
class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;
  const TvSeriesDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class TvSeriesDetailLoaded extends TvSeriesDetailState {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvSeriesDetailLoaded({
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  TvSeriesDetailLoaded copyWith({
    TvSeriesDetail? tvSeries,
    List<TvSeries>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailLoaded(
      tvSeries: tvSeries ?? this.tvSeries,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [tvSeries, recommendations, isAddedToWatchlist, watchlistMessage];
}
