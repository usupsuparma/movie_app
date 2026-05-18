import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/presentation/bloc/movie/movie_list_event.dart';

// Test implementation for abstract MovieListEvent
class _TestMovieListEvent extends MovieListEvent {
  const _TestMovieListEvent();
}

void main() {
  group('MovieListEvent', () {
    group('FetchNowPlayingMovies', () {
      test('supports value equality', () {
        const event1 = FetchNowPlayingMovies();
        const event2 = FetchNowPlayingMovies();

        expect(event1, equals(event2));
      });

      test('props returns empty list', () {
        const event = FetchNowPlayingMovies();

        expect(event.props, isEmpty);
      });

      test('supports string conversion', () {
        const event = FetchNowPlayingMovies();

        expect(event.toString(), isNotEmpty);
      });

      test('is instance of MovieListEvent', () {
        const event = FetchNowPlayingMovies();

        expect(event, isA<MovieListEvent>());
      });
    });

    group('FetchPopularMovies', () {
      test('supports value equality', () {
        const event1 = FetchPopularMovies();
        const event2 = FetchPopularMovies();

        expect(event1, equals(event2));
      });

      test('props returns empty list', () {
        const event = FetchPopularMovies();

        expect(event.props, isEmpty);
      });

      test('supports string conversion', () {
        const event = FetchPopularMovies();

        expect(event.toString(), isNotEmpty);
      });

      test('is instance of MovieListEvent', () {
        const event = FetchPopularMovies();

        expect(event, isA<MovieListEvent>());
      });
    });

    group('FetchTopRatedMovies', () {
      test('supports value equality', () {
        const event1 = FetchTopRatedMovies();
        const event2 = FetchTopRatedMovies();

        expect(event1, equals(event2));
      });

      test('props returns empty list', () {
        const event = FetchTopRatedMovies();

        expect(event.props, isEmpty);
      });

      test('supports string conversion', () {
        const event = FetchTopRatedMovies();

        expect(event.toString(), isNotEmpty);
      });

      test('is instance of MovieListEvent', () {
        const event = FetchTopRatedMovies();

        expect(event, isA<MovieListEvent>());
      });
    });

    group('MovieListEvent abstract class', () {
      test('supports value equality for abstract class', () {
        const event1 = _TestMovieListEvent();
        const event2 = _TestMovieListEvent();

        expect(event1, equals(event2));
      });

      test('default props returns empty list', () {
        const event = _TestMovieListEvent();

        expect(event.props, isEmpty);
      });
    });
  });
}
