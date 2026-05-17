import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/usecases/search_tv_series.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_search_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_search_event.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_search_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockSearchTvSeries extends Mock implements SearchTvSeries {}

void main() {
  late _MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = _MockSearchTvSeries();
  });

  TvSeriesSearchBloc makeBloc() =>
      TvSeriesSearchBloc(searchTvSeries: mockSearchTvSeries);

  group('SearchTvSeriesEvent', () {
    const tQuery = 'Breaking Bad';

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'emits [Loading, Loaded] when search succeeds',
      build: () {
        when(() => mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Right(tTvSeriesList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(const SearchTvSeriesEvent(tQuery)),
      expect: () => [
        TvSeriesSearchLoading(),
        TvSeriesSearchLoaded(tTvSeriesList),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'emits [Loading, Error] when search fails',
      build: () {
        when(() => mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(const SearchTvSeriesEvent(tQuery)),
      expect: () => [
        TvSeriesSearchLoading(),
        const TvSeriesSearchError('Server Failure'),
      ],
    );
  });
}
