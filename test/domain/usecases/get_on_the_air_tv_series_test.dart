import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/domain/usecases/get_on_the_air_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late GetOnTheAirTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = GetOnTheAirTvSeries(repository);
  });

  test('should get on the air TV series from the repository', () async {
    repository.onTheAirHandler = () async => Right(tTvSeriesList);

    final result = await usecase.execute();

    expect(result, Right(tTvSeriesList));
  });
}
