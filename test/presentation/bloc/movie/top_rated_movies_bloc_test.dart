import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/failure.dart';
import 'package:movie_app/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_event.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late _MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = _MockGetTopRatedMovies();
  });

  TopRatedMoviesBloc makeBloc() =>
      TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);

  group('FetchTopRatedMovies', () {
    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        TopRatedMoviesLoaded(testMovieList),
      ],
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          () => mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        const TopRatedMoviesError('Server Failure'),
      ],
    );
  });
}
