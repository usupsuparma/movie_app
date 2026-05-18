import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/domain/usecases/get_popular_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late GetPopularTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = GetPopularTvSeries(repository);
  });

  test('should get popular TV series from the repository', () async {
    repository.popularHandler = () async => Right(tTvSeriesList);

    final result = await usecase.execute();

    expect(result, Right(tTvSeriesList));
  });
}
