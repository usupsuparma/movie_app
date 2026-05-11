import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/domain/usecases/get_top_rated_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late GetTopRatedTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = GetTopRatedTvSeries(repository);
  });

  test('should get top rated TV series from the repository', () async {
    repository.topRatedHandler = () async => Right(tTvSeriesList);

    final result = await usecase.execute();

    expect(result, Right(tTvSeriesList));
  });
}
