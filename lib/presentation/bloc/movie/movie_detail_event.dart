import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;
  const FetchMovieDetail(this.id);
  @override
  List<Object> get props => [id];
}

class AddMovieWatchlist extends MovieDetailEvent {
  final dynamic movie;
  const AddMovieWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

class RemoveMovieWatchlist extends MovieDetailEvent {
  final dynamic movie;
  const RemoveMovieWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}
