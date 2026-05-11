import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:g/common/constants.dart';
import 'package:g/common/state_enum.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/presentation/pages/about_page.dart';
import 'package:g/presentation/pages/popular_tv_series_page.dart';
import 'package:g/presentation/pages/search_tv_series_page.dart';
import 'package:g/presentation/pages/top_rated_tv_series_page.dart';
import 'package:g/presentation/pages/tv_series_detail_page.dart';
import 'package:g/presentation/pages/watchlist_movies_page.dart';
import 'package:g/presentation/pages/watchlist_tv_series_page.dart';
import 'package:g/presentation/provider/tv_series_list_notifier.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(
      () => Provider.of<TvSeriesListNotifier>(context, listen: false)
        ..fetchOnTheAirTvSeries()
        ..fetchPopularTvSeries()
        ..fetchTopRatedTvSeries(),
    );
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
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  if (data.onTheAirState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.onTheAirState == RequestState.Loaded) {
                    return TvSeriesList(data.onTheAirTvSeries);
                  }
                  return Text(data.message.isEmpty ? 'Failed' : data.message);
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvSeriesPage.routeName),
              ),
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  if (data.popularState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.popularState == RequestState.Loaded) {
                    return TvSeriesList(data.popularTvSeries);
                  }
                  return Text(data.message.isEmpty ? 'Failed' : data.message);
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedTvSeriesPage.routeName,
                ),
              ),
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  if (data.topRatedState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.topRatedState == RequestState.Loaded) {
                    return TvSeriesList(data.topRatedTvSeries);
                  }
                  return Text(data.message.isEmpty ? 'Failed' : data.message);
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

