import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/usecases/get_watchlist_movies.dart';
import 'package:g/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:g/presentation/bloc/movie/watchlist_movie_event.dart';
import 'package:g/presentation/bloc/movie/watchlist_movie_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late _MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = _MockGetWatchlistMovies();
  });

  WatchlistMovieBloc makeBloc() =>
      WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);

  group('FetchWatchlistMovies', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieLoaded(testMovieList),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        const WatchlistMovieError('Database Failure'),
      ],
    );
  });
}
