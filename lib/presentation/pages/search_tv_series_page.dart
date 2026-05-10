import 'package:flutter/material.dart';
import 'package:movie_app/common/constants.dart';
import 'package:movie_app/common/state_enum.dart';
import 'package:movie_app/presentation/provider/tv_series_search_notifier.dart';
import 'package:movie_app/presentation/widgets/tv_series_card_list.dart';
import 'package:provider/provider.dart';

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
                Provider.of<TvSeriesSearchNotifier>(context, listen: false)
                    .fetchTvSeriesSearch(query);
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
            Consumer<TvSeriesSearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.Loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) =>
                          TvSeriesCard(data.searchResult[index]),
                      itemCount: data.searchResult.length,
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