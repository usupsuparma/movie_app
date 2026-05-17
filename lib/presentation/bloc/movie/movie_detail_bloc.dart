import 'package:bloc/bloc.dart';
import 'package:g/domain/entities/movie_detail.dart';
import 'package:g/domain/usecases/get_movie_detail.dart';
import 'package:g/domain/usecases/get_movie_recommendations.dart';
import 'package:g/domain/usecases/get_watchlist_status.dart';
import 'package:g/domain/usecases/remove_watchlist.dart';
import 'package:g/domain/usecases/save_watchlist.dart';

import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());
      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult = await getMovieRecommendations.execute(event.id);
      final watchlistStatus = await getWatchListStatus.execute(event.id);

      detailResult.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movie) {
          recommendationResult.fold(
            (failure) => emit(MovieDetailLoaded(
              movie: movie,
              recommendations: [],
              isAddedToWatchlist: watchlistStatus,
            )),
            (recs) => emit(MovieDetailLoaded(
              movie: movie,
              recommendations: recs,
              isAddedToWatchlist: watchlistStatus,
            )),
          );
        },
      );
    });

    on<AddMovieWatchlist>((event, emit) async {
      final movie = event.movie as MovieDetail;
      final result = await saveWatchlist.execute(movie);
      final isAdded = await getWatchListStatus.execute(movie.id);
      if (state is MovieDetailLoaded) {
        final current = state as MovieDetailLoaded;
        result.fold(
          (failure) => emit(current.copyWith(
            isAddedToWatchlist: isAdded,
            watchlistMessage: failure.message,
          )),
          (msg) => emit(current.copyWith(
            isAddedToWatchlist: isAdded,
            watchlistMessage: msg,
          )),
        );
      }
    });

    on<RemoveMovieWatchlist>((event, emit) async {
      final movie = event.movie as MovieDetail;
      final result = await removeWatchlist.execute(movie);
      final isAdded = await getWatchListStatus.execute(movie.id);
      if (state is MovieDetailLoaded) {
        final current = state as MovieDetailLoaded;
        result.fold(
          (failure) => emit(current.copyWith(
            isAddedToWatchlist: isAdded,
            watchlistMessage: failure.message,
          )),
          (msg) => emit(current.copyWith(
            isAddedToWatchlist: isAdded,
            watchlistMessage: msg,
          )),
        );
      }
    });
  }
}
