import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:g/domain/usecases/get_popular_tv_series.dart';
import 'package:g/domain/usecases/get_top_rated_tv_series.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_list_event.dart';
import 'package:g/presentation/bloc/tv_series/tv_series_list_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetOnTheAirTvSeries extends Mock implements GetOnTheAirTvSeries {}

class _MockGetPopularTvSeries extends Mock implements GetPopularTvSeries {}

class _MockGetTopRatedTvSeries extends Mock implements GetTopRatedTvSeries {}

void main() {
  late _MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;
  late _MockGetPopularTvSeries mockGetPopularTvSeries;
  late _MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = _MockGetOnTheAirTvSeries();
    mockGetPopularTvSeries = _MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = _MockGetTopRatedTvSeries();
  });

  TvSeriesListBloc makeBloc() => TvSeriesListBloc(
    getOnTheAirTvSeries: mockGetOnTheAirTvSeries,
    getPopularTvSeries: mockGetPopularTvSeries,
    getTopRatedTvSeries: mockGetTopRatedTvSeries,
  );

  group('FetchOnTheAirTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetOnTheAirTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
      expect: () => [TvSeriesListLoading(), TvSeriesListLoaded(tTvSeriesList)],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetOnTheAirTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
      expect: () => [
        TvSeriesListLoading(),
        const TvSeriesListError('Server Failure'),
      ],
    );
  });

  group('FetchPopularTvSeriesList', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularTvSeriesList()),
      expect: () => [TvSeriesListLoading(), TvSeriesListLoaded(tTvSeriesList)],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularTvSeriesList()),
      expect: () => [
        TvSeriesListLoading(),
        const TvSeriesListError('Server Failure'),
      ],
    );
  });

  group('FetchTopRatedTvSeriesList', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetTopRatedTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeriesList()),
      expect: () => [TvSeriesListLoading(), TvSeriesListLoaded(tTvSeriesList)],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetTopRatedTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeriesList()),
      expect: () => [
        TvSeriesListLoading(),
        const TvSeriesListError('Server Failure'),
      ],
    );
  });

  group('TvSeriesListEvent props', () {
    test('FetchOnTheAirTvSeries has correct props', () {
      expect(FetchOnTheAirTvSeries().props, isEmpty);
    });

    test('FetchPopularTvSeriesList has correct props', () {
      expect(FetchPopularTvSeriesList().props, isEmpty);
    });

    test('FetchTopRatedTvSeriesList has correct props', () {
      expect(FetchTopRatedTvSeriesList().props, isEmpty);
    });
  });
}
