import 'package:http/http.dart' as http;
import 'package:movie_app/common/ssl_pinning.dart';
import 'package:movie_app/data/datasources/db/database_helper.dart';
import 'package:movie_app/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/data/datasources/tv_series_local_data_source.dart';
import 'package:movie_app/data/datasources/tv_series_remote_data_source.dart';
import 'package:movie_app/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/data/repositories/tv_series_repository_impl.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';
import 'package:movie_app/domain/repositories/tv_series_repository.dart';
import 'package:movie_app/domain/usecases/get_movie_detail.dart';
import 'package:movie_app/domain/usecases/get_movie_recommendations.dart';
import 'package:movie_app/domain/usecases/get_now_playing_movies.dart';
import 'package:movie_app/domain/usecases/get_popular_movies.dart';
import 'package:movie_app/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_app/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:movie_app/domain/usecases/get_popular_tv_series.dart';
import 'package:movie_app/domain/usecases/get_top_rated_tv_series.dart';
import 'package:movie_app/domain/usecases/get_tv_series_detail.dart';
import 'package:movie_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:movie_app/domain/usecases/get_watchlist_movies.dart';
import 'package:movie_app/domain/usecases/get_watchlist_status.dart';
import 'package:movie_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:movie_app/domain/usecases/get_watchlist_tv_series.dart';
import 'package:movie_app/domain/usecases/remove_watchlist.dart';
import 'package:movie_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:movie_app/domain/usecases/save_watchlist.dart';
import 'package:movie_app/domain/usecases/save_watchlist_tv_series.dart';
import 'package:movie_app/domain/usecases/search_movies.dart';
import 'package:movie_app/domain/usecases/search_tv_series.dart';
import 'package:movie_app/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/movie_search_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_search_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // bloc
  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(() => PopularMoviesBloc(getPopularMovies: locator()));
  locator.registerFactory(
    () => TopRatedMoviesBloc(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => MovieSearchBloc(searchMovies: locator()));
  locator.registerFactory(
    () => WatchlistMovieBloc(getWatchlistMovies: locator()),
  );
  locator.registerFactory(
    () => TvSeriesListBloc(
      getOnTheAirTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailBloc(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchlistStatusTvSeries: locator(),
      saveWatchlistTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(() => TvSeriesSearchBloc(searchTvSeries: locator()));
  locator.registerFactory(
    () => PopularTvSeriesBloc(getPopularTvSeries: locator()),
  );
  locator.registerFactory(
    () => TopRatedTvSeriesBloc(getTopRatedTvSeries: locator()),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesBloc(getWatchlistTvSeries: locator()),
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
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  final sslClient = await createSslPinnedClient();
  locator.registerLazySingleton<http.Client>(() => sslClient);
}
