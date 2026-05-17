import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/presentation/pages/movie_detail_page.dart';
import 'package:g/presentation/widgets/movie_card_list.dart';

class TestNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount++;
    super.didPush(route, previousRoute);
  }
}

Widget _makeTestableWidget({
  required Movie movie,
  required TestNavigatorObserver observer,
}) {
  return MaterialApp(
    navigatorObservers: [observer],
    onGenerateRoute: (settings) {
      if (settings.name == MovieDetailPage.routeName) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Scaffold(body: Text('movie detail page')),
        );
      }

      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => Scaffold(body: Center(child: MovieCard(movie))),
      );
    },
  );
}

void main() {
  testWidgets('MovieCard should display title and overview', (
    WidgetTester tester,
  ) async {
    final movie = Movie(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genreIds: const [1, 2],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Movie overview',
      popularity: 10,
      posterPath: '/poster.jpg',
      releaseDate: '2020-01-01',
      title: 'Movie Title',
      video: false,
      voteAverage: 8,
      voteCount: 100,
    );
    final observer = TestNavigatorObserver();

    await tester.pumpWidget(
      _makeTestableWidget(movie: movie, observer: observer),
    );

    expect(find.text('Movie Title'), findsOneWidget);
    expect(find.text('Movie overview'), findsOneWidget);
  });

  testWidgets('MovieCard should navigate to detail page on tap', (
    WidgetTester tester,
  ) async {
    final movie = Movie(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genreIds: const [1, 2],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Movie overview',
      popularity: 10,
      posterPath: '/poster.jpg',
      releaseDate: '2020-01-01',
      title: 'Movie Title',
      video: false,
      voteAverage: 8,
      voteCount: 100,
    );
    final observer = TestNavigatorObserver();

    await tester.pumpWidget(
      _makeTestableWidget(movie: movie, observer: observer),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(observer.pushCount, 2);
    expect(find.text('movie detail page'), findsOneWidget);
  });

  testWidgets(
    'MovieCard should show fallback text when title or overview is null',
    (WidgetTester tester) async {
      final movie = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: const [1, 2],
        id: 1,
        originalTitle: 'Original Title',
        overview: null,
        popularity: 10,
        posterPath: '/poster.jpg',
        releaseDate: '2020-01-01',
        title: null,
        video: false,
        voteAverage: 8,
        voteCount: 100,
      );
      final observer = TestNavigatorObserver();

      await tester.pumpWidget(
        _makeTestableWidget(movie: movie, observer: observer),
      );

      expect(find.text('-'), findsNWidgets(2));
    },
  );
}
