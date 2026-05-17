import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/common/failure.dart';
import 'package:g/domain/usecases/search_movies.dart';
import 'package:g/presentation/bloc/movie/movie_search_bloc.dart';
import 'package:g/presentation/bloc/movie/movie_search_event.dart';
import 'package:g/presentation/bloc/movie/movie_search_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class _MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late _MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = _MockSearchMovies();
  });

  MovieSearchBloc makeBloc() =>
      MovieSearchBloc(searchMovies: mockSearchMovies);

  group('SearchMoviesEvent', () {
    const tQuery = 'Spider';

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Loaded] when search succeeds',
      build: () {
        when(() => mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(const SearchMoviesEvent(tQuery)),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchLoaded(testMovieList),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Error] when search fails',
      build: () {
        when(() => mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return makeBloc();
      },
      act: (bloc) => bloc.add(const SearchMoviesEvent(tQuery)),
      expect: () => [
        MovieSearchLoading(),
        const MovieSearchError('Server Failure'),
      ],
    );
  });
}
