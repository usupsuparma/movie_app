import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/presentation/bloc/movie/movie_search_event.dart';

// Test implementation for abstract MovieSearchEvent
class _TestMovieSearchEvent extends MovieSearchEvent {
  const _TestMovieSearchEvent();
}

void main() {
  group('MovieSearchEvent', () {
    group('SearchMoviesEvent', () {
      test('supports value equality', () {
        const query = 'Inception';
        const event1 = SearchMoviesEvent(query);
        const event2 = SearchMoviesEvent(query);

        expect(event1, equals(event2));
      });

      test('supports value inequality with different query', () {
        const event1 = SearchMoviesEvent('Inception');
        const event2 = SearchMoviesEvent('Interstellar');

        expect(event1, isNot(event2));
      });

      test('props contains query', () {
        const query = 'Inception';
        const event = SearchMoviesEvent(query);

        expect(event.props, [query]);
      });

      test('has correct query value', () {
        const query = 'Inception';
        const event = SearchMoviesEvent(query);

        expect(event.query, equals(query));
      });

      test('supports string conversion', () {
        const event = SearchMoviesEvent('Inception');

        expect(event.toString(), isNotEmpty);
      });
    });

    group('MovieSearchEvent abstract class', () {
      test('supports value equality for abstract class', () {
        const event1 = _TestMovieSearchEvent();
        const event2 = _TestMovieSearchEvent();

        expect(event1, equals(event2));
      });

      test('default props returns empty list', () {
        const event = _TestMovieSearchEvent();

        expect(event.props, isEmpty);
      });
    });
  });
}
