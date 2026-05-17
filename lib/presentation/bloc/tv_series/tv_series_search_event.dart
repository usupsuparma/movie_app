import 'package:equatable/equatable.dart';

abstract class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();
  @override
  List<Object> get props => [];
}

class SearchTvSeriesEvent extends TvSeriesSearchEvent {
  final String query;
  const SearchTvSeriesEvent(this.query);
  @override
  List<Object> get props => [query];
}
