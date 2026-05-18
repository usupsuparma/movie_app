import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/top_rated_tv_series_event.dart';
import 'package:movie_app/presentation/bloc/tv_series/top_rated_tv_series_state.dart';
import 'package:movie_app/presentation/widgets/tv_series_card_list.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const routeName = '/top-rated-tv-series';

  const TopRatedTvSeriesPage({super.key});

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) =>
                    TvSeriesCard(state.tvSeries[index]),
                itemCount: state.tvSeries.length,
              );
            } else if (state is TopRatedTvSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
