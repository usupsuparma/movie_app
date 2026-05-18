import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:g/presentation/bloc/movie/movie_detail_event.dart';
import 'package:g/presentation/bloc/movie/movie_detail_state.dart';
import 'package:g/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class _MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class _FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class _FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeMovieDetailEvent());
    registerFallbackValue(_FakeMovieDetailState());
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieRecommendations = <Movie>[tMovie];

  Widget makeTestableWidget(Widget body, MovieDetailState state) {
    final bloc = _MockMovieDetailBloc();
    when(() => bloc.state).thenReturn(state);
    when(() => bloc.stream).thenAnswer((_) => Stream.value(state));
    return BlocProvider<MovieDetailBloc>.value(
      value: bloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display loading indicator when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(id: 1), MovieDetailLoading()),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error text when error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        MovieDetailPage(id: 1),
        MovieDetailError('Error message'),
      ),
    );

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display movie detail content when loaded', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        MovieDetailPage(id: 1),
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: tMovieRecommendations,
          isAddedToWatchlist: false,
        ),
      ),
    );

    expect(find.text('title'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('2h 0m'), findsOneWidget);
    expect(find.text('1.0'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
  });

  testWidgets('Recommendation item should be tappable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        MovieDetailPage(id: 1),
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: tMovieRecommendations,
          isAddedToWatchlist: false,
        ),
      ),
    );

    await tester.pump();
    await tester.ensureVisible(find.byType(InkWell).last);
    await tester.pump();
    await tester.tap(find.byType(InkWell).last);
    await tester.pump();

    expect(find.byType(InkWell), findsWidgets);
  });

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          MovieDetailPage(id: 1),
          MovieDetailLoaded(
            movie: testMovieDetail,
            recommendations: <Movie>[],
            isAddedToWatchlist: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          MovieDetailPage(id: 1),
          MovieDetailLoaded(
            movie: testMovieDetail,
            recommendations: <Movie>[],
            isAddedToWatchlist: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      final initialState = MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
        watchlistMessage: '',
      );
      final nextState = MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: <Movie>[],
        isAddedToWatchlist: true,
        watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
      );

      final bloc = _MockMovieDetailBloc();
      when(() => bloc.state).thenReturn(initialState);
      final controller = StreamController<MovieDetailState>.broadcast();
      when(() => bloc.stream).thenAnswer((_) => controller.stream);
      when(() => bloc.add(any())).thenReturn(null);

      await tester.pumpWidget(
        BlocProvider<MovieDetailBloc>.value(
          value: bloc,
          child: MaterialApp(home: MovieDetailPage(id: 1)),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      final watchlistButton = find.widgetWithText(FilledButton, 'Watchlist');
      await tester.ensureVisible(watchlistButton);
      await tester.pump();

      await tester.tap(watchlistButton);
      await tester.pump();
      verify(() => bloc.add(any(that: isA<AddMovieWatchlist>()))).called(1);
      controller.add(nextState);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(MovieDetailBloc.watchlistAddSuccessMessage),
        findsOneWidget,
      );

      await controller.close();
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      final initialState = MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
        watchlistMessage: '',
      );
      final nextState = MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      );

      final bloc = _MockMovieDetailBloc();
      when(() => bloc.state).thenReturn(initialState);
      final controller = StreamController<MovieDetailState>.broadcast();
      when(() => bloc.stream).thenAnswer((_) => controller.stream);
      when(() => bloc.add(any())).thenReturn(null);

      await tester.pumpWidget(
        BlocProvider<MovieDetailBloc>.value(
          value: bloc,
          child: MaterialApp(home: MovieDetailPage(id: 1)),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      final watchlistButton = find.widgetWithText(FilledButton, 'Watchlist');
      await tester.ensureVisible(watchlistButton);
      await tester.pump();

      await tester.tap(watchlistButton);
      await tester.pump();
      verify(() => bloc.add(any(that: isA<AddMovieWatchlist>()))).called(1);
      controller.add(nextState);
      await tester.pump();
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);

      await controller.close();
    },
  );
}
