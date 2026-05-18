import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/domain/usecases/get_watchlist_tv_series.dart';
import 'package:movie_app/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/watchlist_tv_series_event.dart';
import 'package:movie_app/presentation/bloc/tv_series/watchlist_tv_series_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetWatchlistTvSeries extends Mock implements GetWatchlistTvSeries {}

void main() {
  late _MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = _MockGetWatchlistTvSeries();
  });

  WatchlistTvSeriesBloc makeBloc() =>
      WatchlistTvSeriesBloc(getWatchlistTvSeries: mockGetWatchlistTvSeries);

  group('FetchWatchlistTvSeries', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesLoaded(tTvSeriesList),
      ],
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        const WatchlistTvSeriesError('Database Failure'),
      ],
    );
  });

  group('FetchWatchlistTvSeries event', () {
    test('has correct props', () {
      final event = FetchWatchlistTvSeries();
      expect(event.props, isEmpty);
    });

    test('supports equality', () {
      expect(FetchWatchlistTvSeries(), equals(FetchWatchlistTvSeries()));
    });
  });
}
