import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_search_event.dart';

// Test implementation for abstract TvSeriesSearchEvent
class _TestTvSeriesSearchEvent extends TvSeriesSearchEvent {
  const _TestTvSeriesSearchEvent();
}

void main() {
  group('TvSeriesSearchEvent', () {
    group('SearchTvSeriesEvent', () {
      test('supports value equality', () {
        const query = 'Breaking Bad';
        const event1 = SearchTvSeriesEvent(query);
        const event2 = SearchTvSeriesEvent(query);

        expect(event1, equals(event2));
      });

      test('supports value inequality with different query', () {
        const event1 = SearchTvSeriesEvent('Breaking Bad');
        const event2 = SearchTvSeriesEvent('Game of Thrones');

        expect(event1, isNot(event2));
      });

      test('props contains query', () {
        const query = 'Breaking Bad';
        const event = SearchTvSeriesEvent(query);

        expect(event.props, [query]);
      });

      test('has correct query value', () {
        const query = 'Breaking Bad';
        const event = SearchTvSeriesEvent(query);

        expect(event.query, equals(query));
      });

      test('supports string conversion', () {
        const event = SearchTvSeriesEvent('Breaking Bad');

        expect(event.toString(), isNotEmpty);
      });
    });

    group('TvSeriesSearchEvent abstract class', () {
      test('supports value equality for abstract class', () {
        const event1 = _TestTvSeriesSearchEvent();
        const event2 = _TestTvSeriesSearchEvent();

        expect(event1, equals(event2));
      });

      test('default props returns empty list', () {
        const event = _TestTvSeriesSearchEvent();

        expect(event.props, isEmpty);
      });
    });
  });
}
