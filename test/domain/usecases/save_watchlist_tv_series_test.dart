import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/domain/usecases/save_watchlist_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(repository);
  });

  test('should save TV series watchlist through the repository', () async {
    repository.saveWatchlistHandler = (_) async =>
        const Right('Added to Watchlist');

    final result = await usecase.execute(tTvSeriesDetail);

    expect(result, const Right('Added to Watchlist'));
  });
}
