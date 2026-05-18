import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/domain/usecases/get_tv_series_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/fake_tv_series_repository.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late FakeTvSeriesRepository repository;

  setUp(() {
    repository = FakeTvSeriesRepository();
    usecase = GetTvSeriesDetail(repository);
  });

  const tId = 1;

  test('should get TV series detail from the repository', () async {
    repository.detailHandler = () async => Right(tTvSeriesDetail);

    final result = await usecase.execute(tId);

    expect(result, Right(tTvSeriesDetail));
  });
}
