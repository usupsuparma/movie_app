import 'package:bloc/bloc.dart';
import 'package:movie_app/domain/entities/tv_series_detail.dart';
import 'package:movie_app/domain/usecases/get_tv_series_detail.dart';
import 'package:movie_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:movie_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:movie_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:movie_app/domain/usecases/save_watchlist_tv_series.dart';

import 'tv_series_detail_event.dart';
import 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(TvSeriesDetailEmpty()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(TvSeriesDetailLoading());
      final detailResult = await getTvSeriesDetail.execute(event.id);
      final recommendationResult = await getTvSeriesRecommendations.execute(
        event.id,
      );
      final watchlistStatus = await getWatchlistStatusTvSeries.execute(
        event.id,
      );

      detailResult.fold(
        (failure) => emit(TvSeriesDetailError(failure.message)),
        (tvSeries) {
          recommendationResult.fold(
            (failure) => emit(
              TvSeriesDetailLoaded(
                tvSeries: tvSeries,
                recommendations: [],
                isAddedToWatchlist: watchlistStatus,
              ),
            ),
            (recs) => emit(
              TvSeriesDetailLoaded(
                tvSeries: tvSeries,
                recommendations: recs,
                isAddedToWatchlist: watchlistStatus,
              ),
            ),
          );
        },
      );
    });

    on<AddTvSeriesWatchlist>((event, emit) async {
      final tvSeries = event.tvSeries as TvSeriesDetail;
      final result = await saveWatchlistTvSeries.execute(tvSeries);
      final isAdded = await getWatchlistStatusTvSeries.execute(tvSeries.id);
      if (state is TvSeriesDetailLoaded) {
        final current = state as TvSeriesDetailLoaded;
        result.fold(
          (failure) => emit(
            current.copyWith(
              isAddedToWatchlist: isAdded,
              watchlistMessage: failure.message,
            ),
          ),
          (msg) => emit(
            current.copyWith(
              isAddedToWatchlist: isAdded,
              watchlistMessage: msg,
            ),
          ),
        );
      }
    });

    on<RemoveTvSeriesWatchlist>((event, emit) async {
      final tvSeries = event.tvSeries as TvSeriesDetail;
      final result = await removeWatchlistTvSeries.execute(tvSeries);
      final isAdded = await getWatchlistStatusTvSeries.execute(tvSeries.id);
      if (state is TvSeriesDetailLoaded) {
        final current = state as TvSeriesDetailLoaded;
        result.fold(
          (failure) => emit(
            current.copyWith(
              isAddedToWatchlist: isAdded,
              watchlistMessage: failure.message,
            ),
          ),
          (msg) => emit(
            current.copyWith(
              isAddedToWatchlist: isAdded,
              watchlistMessage: msg,
            ),
          ),
        );
      }
    });
  }
}
