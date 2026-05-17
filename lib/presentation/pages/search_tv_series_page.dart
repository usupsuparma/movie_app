import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g/common/constants.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_search_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_search_event.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_search_state.dart';
import 'package:g/presentation/widgets/tv_series_card_list.dart';

class SearchTvSeriesPage extends StatelessWidget {
  static const routeName = '/search-tv-series';

  const SearchTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TvSeriesSearchBloc>().add(
                  SearchTvSeriesEvent(query),
                );
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
              builder: (context, state) {
                if (state is TvSeriesSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesSearchLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) =>
                          TvSeriesCard(state.results[index]),
                      itemCount: state.results.length,
                    ),
                  );
                }
                return const Expanded(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
