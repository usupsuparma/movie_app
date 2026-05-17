import 'package:bloc/bloc.dart';
import 'package:g/domain/usecases/get_now_playing_movies.dart';
import 'package:g/domain/usecases/get_popular_movies.dart';
import 'package:g/domain/usecases/get_top_rated_movies.dart';

import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListLoaded(movies)),
      );
    });
    on<FetchPopularMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListLoaded(movies)),
      );
    });
    on<FetchTopRatedMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListLoaded(movies)),
      );
    });
  }
}
