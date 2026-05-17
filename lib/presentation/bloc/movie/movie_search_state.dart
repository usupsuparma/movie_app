import 'package:equatable/equatable.dart';
import 'package:g/domain/entities/movie.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();
  @override
  List<Object?> get props => [];
}

class MovieSearchEmpty extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchError extends MovieSearchState {
  final String message;
  const MovieSearchError(this.message);
  @override
  List<Object?> get props => [message];
}

class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> results;
  const MovieSearchLoaded(this.results);
  @override
  List<Object?> get props => [results];
}
