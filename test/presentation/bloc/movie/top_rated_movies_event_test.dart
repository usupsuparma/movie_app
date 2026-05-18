import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_event.dart';

// Test implementation for abstract TopRatedMoviesEvent
class _TestTopRatedMoviesEvent extends TopRatedMoviesEvent {
  const _TestTopRatedMoviesEvent();
}

void main() {
  group('TopRatedMoviesEvent', () {
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
    });

    group('TopRatedMoviesEvent abstract class', () {
      test('supports value equality for abstract class', () {
        const event1 = _TestTopRatedMoviesEvent();
        const event2 = _TestTopRatedMoviesEvent();

        expect(event1, equals(event2));
      });

      test('default props returns empty list', () {
        const event = _TestTopRatedMoviesEvent();

        expect(event.props, isEmpty);
      });
    });
  });
}
