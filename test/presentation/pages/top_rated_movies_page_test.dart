import 'package:bloc_test/bloc_test.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_event.dart';
import 'package:movie_app/presentation/bloc/movie/top_rated_movies_state.dart';
import 'package:movie_app/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  Widget makeTestableWidget(Widget body, TopRatedMoviesState state) {
    final bloc = _MockTopRatedMoviesBloc();
    when(() => bloc.state).thenReturn(state);
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: bloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(TopRatedMoviesPage(), TopRatedMoviesLoading()),
    );

    expect(find.byType(Center), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(TopRatedMoviesPage(), TopRatedMoviesLoaded(<Movie>[])),
    );

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        TopRatedMoviesPage(),
        TopRatedMoviesError('Error message'),
      ),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
