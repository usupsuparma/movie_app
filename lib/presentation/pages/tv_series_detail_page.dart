import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:g/common/constants.dart';
import 'package:g/common/state_enum.dart';
import 'package:g/domain/entities/genre.dart';
import 'package:g/domain/entities/season.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/entities/tv_series_detail.dart';
import 'package:g/presentation/provider/tv_series_detail_notifier.dart';
import 'package:provider/provider.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = '/tv-series-detail';

  const TvSeriesDetailPage({required this.id, super.key});

  final int id;

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .fetchTvSeriesDetail(widget.id);
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvSeriesDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeriesState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.tvSeriesState == RequestState.Loaded) {
            return SafeArea(
              child: TvSeriesDetailContent(
                provider.tvSeries,
                provider.recommendations,
                provider.isAddedToWatchlist,
              ),
            );
          }
          return Center(child: Text(provider.message));
        },
      ),
    );
  }
}

class TvSeriesDetailContent extends StatelessWidget {
  const TvSeriesDetailContent(
    this.tvSeries,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 56),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tvSeries.name, style: kHeading5),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<TvSeriesDetailNotifier>(
                                    context,
                                    listen: false,
                                  ).addWatchlist(tvSeries);
                                } else {
                                  await Provider.of<TvSeriesDetailNotifier>(
                                    context,
                                    listen: false,
                                  ).removeFromWatchlist(tvSeries);
                                }

                                final message =
                                    Provider.of<TvSeriesDetailNotifier>(
                                  context,
                                  listen: false,
                                ).watchlistMessage;

                                if (message ==
                                        TvSeriesDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvSeriesDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(message),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tvSeries.genres)),
                            Text(_showDuration(tvSeries.episodeRunTime)),
                            Text('First Air Date: ${tvSeries.firstAirDate}'),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tvSeries.overview),
                            const SizedBox(height: 16),
                            Text('Seasons & Episodes', style: kHeading6),
                            Text(
                              '${tvSeries.numberOfSeasons} seasons, ${tvSeries.numberOfEpisodes} episodes',
                            ),
                            const SizedBox(height: 8),
                            Text(_showSeasons(tvSeries.seasons)),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            Consumer<TvSeriesDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final item = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.routeName,
                                                arguments: item.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$BASE_IMAGE_URL${item.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((genre) => genre.name).join(', ');
  }

  String _showDuration(List<int> episodeRunTime) {
    if (episodeRunTime.isEmpty) {
      return '-';
    }

    final runtime = episodeRunTime.first;
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m / episode';
    }
    return '${minutes}m / episode';
  }

  String _showSeasons(List<Season> seasons) {
    if (seasons.isEmpty) {
      return '-';
    }

    return seasons
        .map((season) => 'Season ${season.seasonNumber}: ${season.episodeCount} episodes')
        .join('\n');
  }
}
