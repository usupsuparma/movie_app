import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/domain/usecases/get_movie_detail.dart';
import 'package:movie_app/domain/usecases/get_movie_recommendations.dart';
import 'package:movie_app/domain/usecases/get_watchlist_status.dart';
import 'package:movie_app/domain/usecases/remove_watchlist.dart';
import 'package:movie_app/domain/usecases/save_watchlist.dart';
import 'package:movie_app/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/movie_detail_event.dart';
import 'package:movie_app/presentation/bloc/movie/movie_detail_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

// Concrete subclass that does NOT override props, exercising the base class getter.
class _ConcreteMovieDetailEvent extends MovieDetailEvent {
  const _ConcreteMovieDetailEvent();
}

// ---------------------------------------------------------------------------
// Event & State equality tests (exercises props getters for coverage)
// ---------------------------------------------------------------------------
void _eventEqualityTests() {
  group('MovieDetailEvent equality', () {
    test('FetchMovieDetail props', () {
      expect(const FetchMovieDetail(1), const FetchMovieDetail(1));
      expect(const FetchMovieDetail(1).props, [1]);
    });

    test('AddMovieWatchlist props', () {
      expect(
        AddMovieWatchlist(testMovieDetail),
        AddMovieWatchlist(testMovieDetail),
      );
      expect(AddMovieWatchlist(testMovieDetail).props, [testMovieDetail]);
    });

    test('RemoveMovieWatchlist props', () {
      expect(
        RemoveMovieWatchlist(testMovieDetail),
        RemoveMovieWatchlist(testMovieDetail),
      );
      expect(RemoveMovieWatchlist(testMovieDetail).props, [testMovieDetail]);
    });

    test('MovieDetailEvent base props', () {
      // FetchMovieDetail inherits from MovieDetailEvent; base props list
      // is overridden by subclass but the const constructor is exercised.
      expect(const FetchMovieDetail(1) == const FetchMovieDetail(1), isTrue);
      // Exercise the base class props getter directly via a subclass that
      // doesn't override it.
      expect(const _ConcreteMovieDetailEvent().props, isEmpty);
    });
  });

  group('MovieDetailLoaded copyWith fallback', () {
    test('keeps existing fields when no arguments provided', () {
      final state = MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: testMovieList,
        isAddedToWatchlist: true,
        watchlistMessage: 'msg',
      );
      final updated = state.copyWith();
      expect(updated.movie, testMovieDetail);
      expect(updated.recommendations, testMovieList);
      expect(updated.isAddedToWatchlist, true);
      expect(updated.watchlistMessage, 'msg');
    });
  });
}

class _MockGetMovieDetail extends Mock implements GetMovieDetail {}

class _MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

class _MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class _MockSaveWatchlist extends Mock implements SaveWatchlist {}

class _MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  _eventEqualityTests();

  late _MockGetMovieDetail mockGetMovieDetail;
  late _MockGetMovieRecommendations mockGetMovieRecommendations;
  late _MockGetWatchListStatus mockGetWatchListStatus;
  late _MockSaveWatchlist mockSaveWatchlist;
  late _MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = _MockGetMovieDetail();
    mockGetMovieRecommendations = _MockGetMovieRecommendations();
    mockGetWatchListStatus = _MockGetWatchListStatus();
    mockSaveWatchlist = _MockSaveWatchlist();
    mockRemoveWatchlist = _MockRemoveWatchlist();
  });

  MovieDetailBloc makeBloc() => MovieDetailBloc(
    getMovieDetail: mockGetMovieDetail,
    getMovieRecommendations: mockGetMovieRecommendations,
    getWatchListStatus: mockGetWatchListStatus,
    saveWatchlist: mockSaveWatchlist,
    removeWatchlist: mockRemoveWatchlist,
  );

  const tId = 1;
  final tLoadedState = MovieDetailLoaded(
    movie: testMovieDetail,
    recommendations: testMovieList,
    isAddedToWatchlist: false,
  );

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          () => mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          () => mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [MovieDetailLoading(), tLoadedState],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [Loading, Loaded] when recommendations fail',
      build: () {
        when(
          () => mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          () => mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Error')));
        when(
          () => mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: const [],
          isAddedToWatchlist: false,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [Loading, Error] when detail fetch fails',
      build: () {
        when(
          () => mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          () => mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          () => mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError('Server Failure'),
      ],
    );
  });

  group('AddMovieWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated Loaded state with success message',
      build: () {
        when(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => tLoadedState,
      act: (bloc) => bloc.add(AddMovieWatchlist(testMovieDetail)),
      expect: () => [
        tLoadedState.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated Loaded state with failure message',
      build: () {
        when(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => tLoadedState,
      act: (bloc) => bloc.add(AddMovieWatchlist(testMovieDetail)),
      expect: () => [
        tLoadedState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits nothing when state is not MovieDetailLoaded',
      build: () {
        when(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => MovieDetailEmpty(),
      act: (bloc) => bloc.add(AddMovieWatchlist(testMovieDetail)),
      expect: () => [],
    );
  });

  group('RemoveMovieWatchlist', () {
    final tLoadedAdded = tLoadedState.copyWith(isAddedToWatchlist: true);

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated Loaded state with remove success message',
      build: () {
        when(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => tLoadedAdded,
      act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
      expect: () => [
        tLoadedAdded.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated Loaded state with remove failure message',
      build: () {
        when(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Remove failed')));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => tLoadedAdded,
      act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
      expect: () => [
        tLoadedAdded.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Remove failed',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits nothing when state is not MovieDetailLoaded',
      build: () {
        when(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => MovieDetailEmpty(),
      act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
      expect: () => [],
    );
  });
}
