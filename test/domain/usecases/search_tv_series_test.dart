import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/domain/usecases/search_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late SearchTvSeries usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = SearchTvSeries(repository);
  });

  const tQuery = 'Spiderman';

  test('should search TV series from the repository', () async {
    repository.searchHandler = (_) async => Right(tTvSeriesList);

    final result = await usecase.execute(tQuery);

    expect(result, Right(tTvSeriesList));
  });
}
