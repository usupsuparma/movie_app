import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/domain/usecases/get_watchlist_status_tv_series.dart';

import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late GetWatchlistStatusTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = GetWatchlistStatusTvSeries(repository);
  });

  const tId = 1;

  test('should get TV series watchlist status from the repository', () async {
    repository.watchlistStatusHandler = (_) async => true;

    final result = await usecase.execute(tId);

    expect(result, true);
  });
}
