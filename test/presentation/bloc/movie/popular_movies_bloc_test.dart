import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/usecases/get_popular_movies.dart';
import 'package:g/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:g/presentation/bloc/movie/popular_movies_event.dart';
import 'package:g/presentation/bloc/movie/popular_movies_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late _MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = _MockGetPopularMovies();
  });

  PopularMoviesBloc makeBloc() =>
      PopularMoviesBloc(getPopularMovies: mockGetPopularMovies);

  group('FetchPopularMovies', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        PopularMoviesLoaded(testMovieList),
      ],
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        const PopularMoviesError('Server Failure'),
      ],
    );
  });
}
