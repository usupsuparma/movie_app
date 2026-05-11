
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g/common/constants.dart';
import 'package:g/common/utils.dart';
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
import 'package:g/presentation/provider/movie_detail_notifier.dart';
import 'package:g/presentation/provider/movie_list_notifier.dart';
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
import 'package:provider/provider.dart';
import 'package:g/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
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
              return MaterialPageRoute(builder: (_) => const HomeTvSeriesPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case PopularTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => const PopularTvSeriesPage());
            case TopRatedTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => const TopRatedTvSeriesPage());
            case MovieDetailPage.ROUTE_NAME:
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
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case SearchTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => const SearchTvSeriesPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => const WatchlistTvSeriesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

