import 'package:bloc_test/bloc_test.dart';
import 'package:g/domain/entities/movie.dart';
import 'package:g/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:g/presentation/bloc/movie/popular_movies_event.dart';
import 'package:g/presentation/bloc/movie/popular_movies_state.dart';
import 'package:g/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  Widget makeTestableWidget(Widget body, PopularMoviesState state) {
    final bloc = _MockPopularMoviesBloc();
    when(() => bloc.state).thenReturn(state);
    return BlocProvider<PopularMoviesBloc>.value(
      value: bloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(PopularMoviesPage(), PopularMoviesLoading()),
    );

    expect(find.byType(Center), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(PopularMoviesPage(), PopularMoviesLoaded(<Movie>[])),
    );

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        PopularMoviesPage(),
        PopularMoviesError('Error message'),
      ),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
