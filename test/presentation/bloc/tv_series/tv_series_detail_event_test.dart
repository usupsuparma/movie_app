import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/presentation/bloc/tv_series/tv_series_detail_event.dart';

// Test implementation for abstract TvSeriesDetailEvent
class _TestTvSeriesDetailEvent extends TvSeriesDetailEvent {
  const _TestTvSeriesDetailEvent();
}

void main() {
  group('TvSeriesDetailEvent', () {
    group('FetchTvSeriesDetail', () {
      test('supports value equality', () {
        const id = 123;
        const event1 = FetchTvSeriesDetail(id);
        const event2 = FetchTvSeriesDetail(id);

        expect(event1, equals(event2));
      });

      test('supports value inequality with different id', () {
        const event1 = FetchTvSeriesDetail(123);
        const event2 = FetchTvSeriesDetail(456);

        expect(event1, isNot(event2));
      });

      test('props contains id', () {
        const id = 123;
        const event = FetchTvSeriesDetail(id);

        expect(event.props, [id]);
      });

      test('has correct id value', () {
        const id = 123;
        const event = FetchTvSeriesDetail(id);

        expect(event.id, equals(id));
      });

      test('supports string conversion', () {
        const event = FetchTvSeriesDetail(123);

        expect(event.toString(), isNotEmpty);
      });
    });

    group('AddTvSeriesWatchlist', () {
      test('supports value equality', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event1 = AddTvSeriesWatchlist(tvSeries);
        final event2 = AddTvSeriesWatchlist(tvSeries);

        expect(event1, equals(event2));
      });

      test('supports value inequality with different tvSeries', () {
        final tvSeries1 = {'id': 1, 'name': 'Breaking Bad'};
        final tvSeries2 = {'id': 2, 'name': 'Game of Thrones'};
        final event1 = AddTvSeriesWatchlist(tvSeries1);
        final event2 = AddTvSeriesWatchlist(tvSeries2);

        expect(event1, isNot(event2));
      });

      test('props contains tvSeries', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event = AddTvSeriesWatchlist(tvSeries);

        expect(event.props, [tvSeries]);
      });

      test('has correct tvSeries value', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event = AddTvSeriesWatchlist(tvSeries);

        expect(event.tvSeries, equals(tvSeries));
      });

      test('supports string conversion', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event = AddTvSeriesWatchlist(tvSeries);

        expect(event.toString(), isNotEmpty);
      });
    });

    group('RemoveTvSeriesWatchlist', () {
      test('supports value equality', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event1 = RemoveTvSeriesWatchlist(tvSeries);
        final event2 = RemoveTvSeriesWatchlist(tvSeries);

        expect(event1, equals(event2));
      });

      test('supports value inequality with different tvSeries', () {
        final tvSeries1 = {'id': 1, 'name': 'Breaking Bad'};
        final tvSeries2 = {'id': 2, 'name': 'Game of Thrones'};
        final event1 = RemoveTvSeriesWatchlist(tvSeries1);
        final event2 = RemoveTvSeriesWatchlist(tvSeries2);

        expect(event1, isNot(event2));
      });

      test('props contains tvSeries', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event = RemoveTvSeriesWatchlist(tvSeries);

        expect(event.props, [tvSeries]);
      });

      test('has correct tvSeries value', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event = RemoveTvSeriesWatchlist(tvSeries);

        expect(event.tvSeries, equals(tvSeries));
      });

      test('supports string conversion', () {
        final tvSeries = {'id': 1, 'name': 'Breaking Bad'};
        final event = RemoveTvSeriesWatchlist(tvSeries);

        expect(event.toString(), isNotEmpty);
      });
    });

    group('TvSeriesDetailEvent abstract class', () {
      test('supports value equality for abstract class', () {
        const event1 = _TestTvSeriesDetailEvent();
        const event2 = _TestTvSeriesDetailEvent();

        expect(event1, equals(event2));
      });

      test('default props returns empty list', () {
        const event = _TestTvSeriesDetailEvent();

        expect(event.props, isEmpty);
      });
    });
  });
}
