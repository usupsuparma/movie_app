import 'package:bloc/bloc.dart';
import 'package:g/domain/usecases/search_movies.dart';

import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchEmpty()) {
    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieSearchLoading());
      final result = await searchMovies.execute(event.query);
      result.fold(
        (failure) => emit(MovieSearchError(failure.message)),
        (movies) => emit(MovieSearchLoaded(movies)),
      );
    });
  }
}
