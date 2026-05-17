import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g/common/constants.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:g/presentation/bloc/movie/movie_list_event.dart';
import 'package:g/presentation/bloc/movie/movie_list_state.dart';
import 'package:g/presentation/pages/about_page.dart';
import 'package:g/presentation/pages/home_tv_series_page.dart';
import 'package:g/presentation/pages/movie_detail_page.dart';
import 'package:g/presentation/pages/popular_movies_page.dart';
import 'package:g/presentation/pages/search_page.dart';
import 'package:g/presentation/pages/top_rated_movies_page.dart';
import 'package:g/presentation/pages/watchlist_movies_page.dart';
import 'package:g/presentation/pages/watchlist_tv_series_page.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final bloc = context.read<MovieListBloc>();
      bloc.add(FetchNowPlayingMovies());
      bloc.add(FetchPopularMovies());
      bloc.add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('movie_app'),
              accountEmail: Text('movie_app@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.live_tv),
              title: Text('TV Series'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  HomeTvSeriesPage.routeName,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add_check),
              title: Text('Watchlist TV Series'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvSeriesPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('movie_app'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state is MovieListLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MovieListLoaded) {
                    return MovieList(state.movies);
                  } else if (state is MovieListError) {
                    return Text(state.message);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state is MovieListLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MovieListLoaded) {
                    return MovieList(state.movies);
                  } else if (state is MovieListError) {
                    return Text(state.message);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state is MovieListLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MovieListLoaded) {
                    return MovieList(state.movies);
                  } else if (state is MovieListError) {
                    return Text(state.message);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
