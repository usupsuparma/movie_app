import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/domain/usecases/get_popular_tv_series.dart';
import 'package:movie_app/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/popular_tv_series_event.dart';
import 'package:movie_app/presentation/bloc/tv_series/popular_tv_series_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetPopularTvSeries extends Mock implements GetPopularTvSeries {}

void main() {
  late _MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = _MockGetPopularTvSeries();
  });

  PopularTvSeriesBloc makeBloc() =>
      PopularTvSeriesBloc(getPopularTvSeries: mockGetPopularTvSeries);

  group('FetchPopularTvSeries', () {
    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesLoaded(tTvSeriesList),
      ],
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        const PopularTvSeriesError('Server Failure'),
      ],
    );
  });

  group('FetchPopularTvSeries event', () {
    test('has correct props', () {
      final event = FetchPopularTvSeries();
      expect(event.props, isEmpty);
    });

    test('supports equality', () {
      expect(FetchPopularTvSeries(), equals(FetchPopularTvSeries()));
    });
  });
}
