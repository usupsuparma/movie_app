import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/domain/usecases/get_tv_series_recommendations.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(repository);
  });

  const tId = 1;

  test('should get TV series recommendations from the repository', () async {
    repository.recommendationsHandler = () async => Right(tTvSeriesList);

    final result = await usecase.execute(tId);

    expect(result, Right(tTvSeriesList));
  });
}
