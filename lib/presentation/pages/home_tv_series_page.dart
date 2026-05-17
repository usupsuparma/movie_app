import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g/common/constants.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:g/presentation/bloc/tv_series/popular_tv_series_event.dart';
import 'package:g/presentation/bloc/tv_series/popular_tv_series_state.dart';
import 'package:g/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:g/presentation/bloc/tv_series/top_rated_tv_series_event.dart';
import 'package:g/presentation/bloc/tv_series/top_rated_tv_series_state.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_list_event.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_list_state.dart';
import 'package:g/presentation/pages/about_page.dart';
import 'package:g/presentation/pages/popular_tv_series_page.dart';
import 'package:g/presentation/pages/search_tv_series_page.dart';
import 'package:g/presentation/pages/top_rated_tv_series_page.dart';
import 'package:g/presentation/pages/tv_series_detail_page.dart';
import 'package:g/presentation/pages/watchlist_movies_page.dart';
import 'package:g/presentation/pages/watchlist_tv_series_page.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const routeName = '/home-tv-series';

  const HomeTvSeriesPage({super.key});

  @override
  State<HomeTvSeriesPage> createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesListBloc>().add(FetchOnTheAirTvSeries());
      context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries());
      context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
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
                backgroundImage: const AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: const Text('movie_app'),
              accountEmail: const Text('movie_app@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_tv),
              title: const Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add_check),
              title: const Text('Watchlist TV Series'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvSeriesPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvSeriesPage.routeName);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('On The Air', style: kHeading6),
              BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
                builder: (context, state) {
                  if (state is TvSeriesListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TvSeriesListLoaded) {
                    return TvSeriesList(state.tvSeries);
                  } else if (state is TvSeriesListError) {
                    return Text(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvSeriesPage.routeName),
              ),
              BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
                builder: (context, state) {
                  if (state is PopularTvSeriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PopularTvSeriesLoaded) {
                    return TvSeriesList(state.tvSeries);
                  } else if (state is PopularTvSeriesError) {
                    return Text(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedTvSeriesPage.routeName,
                ),
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
                builder: (context, state) {
                  if (state is TopRatedTvSeriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedTvSeriesLoaded) {
                    return TvSeriesList(state.tvSeries);
                  } else if (state is TopRatedTvSeriesError) {
                    return Text(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  const TvSeriesList(this.tvSeries, {super.key});

  final List<TvSeries> tvSeries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.routeName,
                  arguments: item.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${item.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
