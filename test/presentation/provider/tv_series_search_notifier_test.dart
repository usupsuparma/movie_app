import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/common/state_enum.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/repositories/tv_series_repository.dart';
import 'package:movie_app/domain/usecases/search_tv_series.dart';
import 'package:movie_app/presentation/provider/tv_series_search_notifier.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeSearchTvSeries implements SearchTvSeries {
  Future<Either<Failure, List<TvSeries>>> Function(String query)? handler;

  @override
  TvSeriesRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<TvSeries>>> execute(String query) =>
      handler!(query);
}

void main() {
  late TvSeriesSearchNotifier notifier;
  late FakeSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = FakeSearchTvSeries();
    notifier = TvSeriesSearchNotifier(searchTvSeries: mockSearchTvSeries);
  });

  test('fetchTvSeriesSearch should return search results', () async {
    mockSearchTvSeries.handler = (query) async => Right(tTvSeriesList);

    await notifier.fetchTvSeriesSearch('query');

    expect(notifier.state, RequestState.Loaded);
    expect(notifier.searchResult, tTvSeriesList);
  });

  test('fetchTvSeriesSearch should set error state on failure', () async {
    mockSearchTvSeries.handler = (query) async => Left(ServerFailure('Failed'));

    await notifier.fetchTvSeriesSearch('query');

    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Failed');
  });
}
