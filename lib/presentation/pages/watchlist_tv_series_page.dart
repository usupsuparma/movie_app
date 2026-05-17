import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g/common/utils.dart';
import 'package:g/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:g/presentation/bloc/tv_series/watchlist_tv_series_event.dart';
import 'package:g/presentation/bloc/tv_series/watchlist_tv_series_state.dart';
import 'package:g/presentation/widgets/tv_series_card_list.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const routeName = '/watchlist-tv-series';

  const WatchlistTvSeriesPage({super.key});

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
          builder: (context, state) {
            if (state is WatchlistTvSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchlistTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) =>
                    TvSeriesCard(state.tvSeries[index]),
                itemCount: state.tvSeries.length,
              );
            } else if (state is WatchlistTvSeriesError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
