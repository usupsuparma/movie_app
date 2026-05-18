import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/domain/usecases/get_watchlist_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = GetWatchlistTvSeries(repository);
  });

  test('should get TV series watchlist from the repository', () async {
    repository.watchlistHandler = () async => Right(tTvSeriesList);

    final result = await usecase.execute();

    expect(result, Right(tTvSeriesList));
  });
}
