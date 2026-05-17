import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/usecases/get_now_playing_movies.dart';
import 'package:g/domain/usecases/get_popular_movies.dart';
import 'package:g/domain/usecases/get_top_rated_movies.dart';
import 'package:g/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:g/presentation/bloc/movie/movie_list_event.dart';
import 'package:g/presentation/bloc/movie/movie_list_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class _MockGetPopularMovies extends Mock implements GetPopularMovies {}

class _MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late _MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late _MockGetPopularMovies mockGetPopularMovies;
  late _MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = _MockGetNowPlayingMovies();
    mockGetPopularMovies = _MockGetPopularMovies();
    mockGetTopRatedMovies = _MockGetTopRatedMovies();
  });

  MovieListBloc makeBloc() => MovieListBloc(
    getNowPlayingMovies: mockGetNowPlayingMovies,
    getPopularMovies: mockGetPopularMovies,
    getTopRatedMovies: mockGetTopRatedMovies,
  );

  group('FetchNowPlayingMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [MovieListLoading(), MovieListLoaded(testMovieList)],
    );

    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListLoading(),
        const MovieListError('Server Failure'),
      ],
    );
  });

  group('FetchPopularMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [MovieListLoading(), MovieListLoaded(testMovieList)],
    );

    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        MovieListLoading(),
        const MovieListError('Server Failure'),
      ],
    );
  });

  group('FetchTopRatedMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [MovieListLoading(), MovieListLoaded(testMovieList)],
    );

    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        MovieListLoading(),
        const MovieListError('Server Failure'),
      ],
    );
  });
}
