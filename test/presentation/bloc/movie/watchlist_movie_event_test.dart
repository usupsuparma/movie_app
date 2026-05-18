import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/presentation/bloc/movie/watchlist_movie_event.dart';

// Test implementation for abstract WatchlistMovieEvent
class _TestWatchlistMovieEvent extends WatchlistMovieEvent {
  const _TestWatchlistMovieEvent();
}

void main() {
  group('WatchlistMovieEvent', () {
    group('FetchWatchlistMovies', () {
      test('supports value equality', () {
        const event1 = FetchWatchlistMovies();
        const event2 = FetchWatchlistMovies();

        expect(event1, equals(event2));
      });

      test('props returns empty list', () {
        const event = FetchWatchlistMovies();

        expect(event.props, isEmpty);
      });

      test('supports string conversion', () {
        const event = FetchWatchlistMovies();

        expect(event.toString(), isNotEmpty);
      });
    });

    group('WatchlistMovieEvent abstract class', () {
      test('supports value equality for abstract class', () {
        const event1 = _TestWatchlistMovieEvent();
        const event2 = _TestWatchlistMovieEvent();

        expect(event1, equals(event2));
      });

      test('default props returns empty list', () {
        const event = _TestWatchlistMovieEvent();

        expect(event.props, isEmpty);
      });
    });
  });
}
