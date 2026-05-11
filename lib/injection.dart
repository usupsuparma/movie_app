
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:g/data/datasources/db/database_helper.dart';
import 'package:g/data/datasources/movie_local_data_source.dart';
import 'package:g/data/datasources/movie_remote_data_source.dart';
import 'package:g/data/datasources/tv_series_local_data_source.dart';
import 'package:g/data/datasources/tv_series_remote_data_source.dart';
import 'package:g/data/repositories/movie_repository_impl.dart';
import 'package:g/data/repositories/tv_series_repository_impl.dart';
import 'package:g/domain/repositories/movie_repository.dart';
import 'package:g/domain/repositories/tv_series_repository.dart';
import 'package:g/domain/usecases/get_movie_detail.dart';
import 'package:g/domain/usecases/get_movie_recommendations.dart';
import 'package:g/domain/usecases/get_now_playing_movies.dart';
import 'package:g/domain/usecases/get_popular_movies.dart';
import 'package:g/domain/usecases/get_top_rated_movies.dart';
import 'package:g/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:g/domain/usecases/get_popular_tv_series.dart';
import 'package:g/domain/usecases/get_top_rated_tv_series.dart';
import 'package:g/domain/usecases/get_tv_series_detail.dart';
import 'package:g/domain/usecases/get_tv_series_recommendations.dart';
import 'package:g/domain/usecases/get_watchlist_movies.dart';
import 'package:g/domain/usecases/get_watchlist_status.dart';
import 'package:g/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:g/domain/usecases/get_watchlist_tv_series.dart';
import 'package:g/domain/usecases/remove_watchlist.dart';
import 'package:g/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:g/domain/usecases/save_watchlist.dart';
import 'package:g/domain/usecases/save_watchlist_tv_series.dart';
import 'package:g/domain/usecases/search_movies.dart';
import 'package:g/domain/usecases/search_tv_series.dart';
import 'package:g/presentation/provider/movie_list_notifier.dart';
import 'package:g/presentation/provider/movie_detail_notifier.dart';
import 'package:g/presentation/provider/movie_search_notifier.dart';
import 'package:g/presentation/provider/popular_movies_notifier.dart';
import 'package:g/presentation/provider/top_rated_movies_notifier.dart';
import 'package:g/presentation/provider/popular_tv_series_notifier.dart';
import 'package:g/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:g/presentation/provider/tv_series_detail_notifier.dart';
import 'package:g/presentation/provider/tv_series_list_notifier.dart';
import 'package:g/presentation/provider/tv_series_search_notifier.dart';
import 'package:g/presentation/provider/watchlist_movie_notifier.dart';
import 'package:g/presentation/provider/watchlist_tv_series_notifier.dart';
final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesListNotifier(
      getOnTheAirTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailNotifier(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchlistStatusTvSeries: locator(),
      saveWatchlistTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesSearchNotifier(
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvSeriesNotifier(locator()),
  );
  locator.registerFactory(
    () => TopRatedTvSeriesNotifier(getTopRatedTvSeries: locator()),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesNotifier(getWatchlistTvSeries: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
    locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
    locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}

