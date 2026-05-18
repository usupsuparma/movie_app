import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/domain/usecases/remove_watchlist_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = RemoveWatchlistTvSeries(repository);
  });

  test('should remove TV series watchlist through the repository', () async {
    repository.removeWatchlistHandler = (_) async =>
        const Right('Removed from Watchlist');

    final result = await usecase.execute(tTvSeriesDetail);

    expect(result, const Right('Removed from Watchlist'));
  });
}
