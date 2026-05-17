import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:g/common/constants.dart';
import 'package:g/domain/entities/genre.dart';
import 'package:g/domain/entities/season.dart';
import 'package:g/domain/entities/tv_series.dart';
import 'package:g/domain/entities/tv_series_detail.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_detail_event.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_detail_state.dart';

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
      if (!mounted) return;
      context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
        builder: (context, state) {
          if (state is TvSeriesDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TvSeriesDetailLoaded) {
            return SafeArea(
              child: BlocListener<TvSeriesDetailBloc, TvSeriesDetailState>(
                listenWhen: (previous, current) {
                  if (previous is TvSeriesDetailLoaded &&
                      current is TvSeriesDetailLoaded) {
                    return previous.watchlistMessage !=
                            current.watchlistMessage &&
                        current.watchlistMessage.isNotEmpty;
                  }
                  return false;
                },
                listener: (context, state) {
                  if (state is TvSeriesDetailLoaded) {
                    final message = state.watchlistMessage;
                    if (message ==
                            TvSeriesDetailBloc.watchlistAddSuccessMessage ||
                        message ==
                            TvSeriesDetailBloc.watchlistRemoveSuccessMessage) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    } else if (message.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(content: Text(message)),
                      );
                    }
                  }
                },
                child: TvSeriesDetailContent(
                  state.tvSeries,
                  state.recommendations,
                  state.isAddedToWatchlist,
                ),
              ),
            );
          }
          if (state is TvSeriesDetailError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
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
          imageUrl: '$baseImageUrl${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
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
                              onPressed: () {
                                final bloc = context.read<TvSeriesDetailBloc>();
                                if (!isAddedWatchlist) {
                                  bloc.add(AddTvSeriesWatchlist(tvSeries));
                                } else {
                                  bloc.add(RemoveTvSeriesWatchlist(tvSeries));
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
                            recommendations.isEmpty
                                ? const SizedBox.shrink()
                                : SizedBox(
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
                                                    '$baseImageUrl${item.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
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
        .map(
          (season) =>
              'Season ${season.seasonNumber}: ${season.episodeCount} episodes',
        )
        .join('\n');
  }
}
