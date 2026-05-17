import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g/common/constants.dart';
import 'package:g/common/utils.dart';
import 'package:g/firebase_options.dart';
import 'package:g/presentation/pages/about_page.dart';
import 'package:g/presentation/pages/home_movie_page.dart';
import 'package:g/presentation/pages/home_tv_series_page.dart';
import 'package:g/presentation/pages/movie_detail_page.dart';
import 'package:g/presentation/pages/popular_movies_page.dart';
import 'package:g/presentation/pages/popular_tv_series_page.dart';
import 'package:g/presentation/pages/search_page.dart';
import 'package:g/presentation/pages/search_tv_series_page.dart';
import 'package:g/presentation/pages/top_rated_movies_page.dart';
import 'package:g/presentation/pages/top_rated_tv_series_page.dart';
import 'package:g/presentation/pages/tv_series_detail_page.dart';
import 'package:g/presentation/pages/watchlist_movies_page.dart';
import 'package:g/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:g/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:g/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:g/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:g/presentation/bloc/movie/movie_search_bloc.dart';
import 'package:g/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_search_bloc.dart';
import 'package:g/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:g/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:g/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:g/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode,
  );

  await di.init();
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MovieListBloc(
            getNowPlayingMovies: di.locator(),
            getPopularMovies: di.locator(),
            getTopRatedMovies: di.locator(),
          ),
        ),
        BlocProvider(
          create: (_) => PopularMoviesBloc(getPopularMovies: di.locator()),
        ),
        BlocProvider(
          create: (_) => TopRatedMoviesBloc(getTopRatedMovies: di.locator()),
        ),
        BlocProvider(
          create: (_) => MovieDetailBloc(
            getMovieDetail: di.locator(),
            getMovieRecommendations: di.locator(),
            getWatchListStatus: di.locator(),
            saveWatchlist: di.locator(),
            removeWatchlist: di.locator(),
          ),
        ),
        BlocProvider(
          create: (_) => MovieSearchBloc(searchMovies: di.locator()),
        ),
        BlocProvider(
          create: (_) => WatchlistMovieBloc(getWatchlistMovies: di.locator()),
        ),
        BlocProvider(
          create: (_) => TvSeriesListBloc(
            getOnTheAirTvSeries: di.locator(),
            getPopularTvSeries: di.locator(),
            getTopRatedTvSeries: di.locator(),
          ),
        ),
        BlocProvider(
          create: (_) => TvSeriesDetailBloc(
            getTvSeriesDetail: di.locator(),
            getTvSeriesRecommendations: di.locator(),
            getWatchlistStatusTvSeries: di.locator(),
            saveWatchlistTvSeries: di.locator(),
            removeWatchlistTvSeries: di.locator(),
          ),
        ),
        BlocProvider(
          create: (_) => TvSeriesSearchBloc(searchTvSeries: di.locator()),
        ),
        BlocProvider(
          create: (_) => PopularTvSeriesBloc(getPopularTvSeries: di.locator()),
        ),
        BlocProvider(
          create: (_) =>
              TopRatedTvSeriesBloc(getTopRatedTvSeries: di.locator()),
        ),
        BlocProvider(
          create: (_) =>
              WatchlistTvSeriesBloc(getWatchlistTvSeries: di.locator()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case HomeTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const HomeTvSeriesPage(),
              );
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case PopularTvSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularTvSeriesPage(),
              );
            case TopRatedTvSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTvSeriesPage(),
              );
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case SearchTvSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const SearchTvSeriesPage(),
              );
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistTvSeriesPage(),
              );
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
