import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/usecases/get_top_rated_tv_series.dart';
import 'package:g/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:g/presentation/bloc/tv_series/top_rated_tv_series_event.dart';
import 'package:g/presentation/bloc/tv_series/top_rated_tv_series_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetTopRatedTvSeries extends Mock implements GetTopRatedTvSeries {}

void main() {
  late _MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = _MockGetTopRatedTvSeries();
  });

  TopRatedTvSeriesBloc makeBloc() =>
      TopRatedTvSeriesBloc(getTopRatedTvSeries: mockGetTopRatedTvSeries);

  group('FetchTopRatedTvSeries', () {
    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(() => mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesLoaded(tTvSeriesList),
      ],
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(() => mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        const TopRatedTvSeriesError('Server Failure'),
      ],
    );
  });

  group('FetchTopRatedTvSeries event', () {
    test('has correct props', () {
      final event = FetchTopRatedTvSeries();
      expect(event.props, isEmpty);
    });

    test('supports equality', () {
      expect(FetchTopRatedTvSeries(), equals(FetchTopRatedTvSeries()));
    });
  });
}
