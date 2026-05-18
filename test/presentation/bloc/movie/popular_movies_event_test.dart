import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/presentation/bloc/movie/popular_movies_event.dart';

// Test implementation for abstract PopularMoviesEvent
class _TestPopularMoviesEvent extends PopularMoviesEvent {
  const _TestPopularMoviesEvent();
}

void main() {
  group('PopularMoviesEvent', () {
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
    });

    group('PopularMoviesEvent abstract class', () {
      test('supports value equality for abstract class', () {
        const event1 = _TestPopularMoviesEvent();
        const event2 = _TestPopularMoviesEvent();

        expect(event1, equals(event2));
      });

      test('default props returns empty list', () {
        const event = _TestPopularMoviesEvent();

        expect(event.props, isEmpty);
      });
    });
  });
}
