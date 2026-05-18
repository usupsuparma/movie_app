import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/domain/usecases/get_tv_series_detail.dart';
import 'package:movie_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:movie_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:movie_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:movie_app/domain/usecases/save_watchlist_tv_series.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_detail_event.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_detail_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetTvSeriesDetail extends Mock implements GetTvSeriesDetail {}

class _MockGetTvSeriesRecommendations extends Mock
    implements GetTvSeriesRecommendations {}

class _MockGetWatchlistStatusTvSeries extends Mock
    implements GetWatchlistStatusTvSeries {}

class _MockSaveWatchlistTvSeries extends Mock
    implements SaveWatchlistTvSeries {}

class _MockRemoveWatchlistTvSeries extends Mock
    implements RemoveWatchlistTvSeries {}

void main() {
  late _MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late _MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late _MockGetWatchlistStatusTvSeries mockGetWatchlistStatusTvSeries;
  late _MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late _MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetTvSeriesDetail = _MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = _MockGetTvSeriesRecommendations();
    mockGetWatchlistStatusTvSeries = _MockGetWatchlistStatusTvSeries();
    mockSaveWatchlistTvSeries = _MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = _MockRemoveWatchlistTvSeries();
  });

  TvSeriesDetailBloc makeBloc() => TvSeriesDetailBloc(
    getTvSeriesDetail: mockGetTvSeriesDetail,
    getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
    getWatchlistStatusTvSeries: mockGetWatchlistStatusTvSeries,
    saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
    removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
  );

  const tId = 1;
  final tLoadedState = TvSeriesDetailLoaded(
    tvSeries: tTvSeriesDetail,
    recommendations: tTvSeriesList,
    isAddedToWatchlist: false,
  );

  group('FetchTvSeriesDetail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetTvSeriesDetail.execute(tId),
        ).thenAnswer((_) async => Right(tTvSeriesDetail));
        when(
          () => mockGetTvSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [TvSeriesDetailLoading(), tLoadedState],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits [Loading, Loaded] when recommendations fail',
      build: () {
        when(
          () => mockGetTvSeriesDetail.execute(tId),
        ).thenAnswer((_) async => Right(tTvSeriesDetail));
        when(
          () => mockGetTvSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Error')));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailLoading(),
        TvSeriesDetailLoaded(
          tvSeries: tTvSeriesDetail,
          recommendations: const [],
          isAddedToWatchlist: false,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits [Loading, Error] when detail fetch fails',
      build: () {
        when(
          () => mockGetTvSeriesDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          () => mockGetTvSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailLoading(),
        const TvSeriesDetailError('Server Failure'),
      ],
    );
  });

  group('AddTvSeriesWatchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits updated Loaded state with success message',
      build: () {
        when(
          () => mockSaveWatchlistTvSeries.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => tLoadedState,
      act: (bloc) => bloc.add(AddTvSeriesWatchlist(tTvSeriesDetail)),
      expect: () => [
        tLoadedState.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits updated Loaded state with failure message',
      build: () {
        when(
          () => mockSaveWatchlistTvSeries.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => tLoadedState,
      act: (bloc) => bloc.add(AddTvSeriesWatchlist(tTvSeriesDetail)),
      expect: () => [
        tLoadedState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits nothing when state is not TvSeriesDetailLoaded',
      build: () {
        when(
          () => mockSaveWatchlistTvSeries.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => TvSeriesDetailEmpty(),
      act: (bloc) => bloc.add(AddTvSeriesWatchlist(tTvSeriesDetail)),
      expect: () => [],
    );
  });

  group('RemoveTvSeriesWatchlist', () {
    final tLoadedAdded = tLoadedState.copyWith(isAddedToWatchlist: true);

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits updated Loaded state with remove success message',
      build: () {
        when(
          () => mockRemoveWatchlistTvSeries.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => tLoadedAdded,
      act: (bloc) => bloc.add(RemoveTvSeriesWatchlist(tTvSeriesDetail)),
      expect: () => [
        tLoadedAdded.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: TvSeriesDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits updated Loaded state with remove failure message',
      build: () {
        when(
          () => mockRemoveWatchlistTvSeries.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Remove failed')));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => tLoadedAdded,
      act: (bloc) => bloc.add(RemoveTvSeriesWatchlist(tTvSeriesDetail)),
      expect: () => [
        tLoadedAdded.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Remove failed',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits nothing when state is not TvSeriesDetailLoaded',
      build: () {
        when(
          () => mockRemoveWatchlistTvSeries.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => TvSeriesDetailEmpty(),
      act: (bloc) => bloc.add(RemoveTvSeriesWatchlist(tTvSeriesDetail)),
      expect: () => [],
    );
  });

  group('TvSeriesDetailEvent props', () {
    test('FetchTvSeriesDetail has correct props', () {
      final event = FetchTvSeriesDetail(tId);
      expect(event.props, [tId]);
      expect(FetchTvSeriesDetail(tId), equals(FetchTvSeriesDetail(tId)));
    });

    test('AddTvSeriesWatchlist has correct props', () {
      final event = AddTvSeriesWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
      expect(
        AddTvSeriesWatchlist(tTvSeriesDetail),
        equals(AddTvSeriesWatchlist(tTvSeriesDetail)),
      );
    });

    test('RemoveTvSeriesWatchlist has correct props', () {
      final event = RemoveTvSeriesWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
      expect(
        RemoveTvSeriesWatchlist(tTvSeriesDetail),
        equals(RemoveTvSeriesWatchlist(tTvSeriesDetail)),
      );
    });
  });
}
