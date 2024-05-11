import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/injectable.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_cubit.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_page_test.mocks.dart';

@GenerateMocks([MovieListCubit, StackRouter])
void main() {
  group('MovieListPage', () {
    late MockMovieListCubit mockMovieListCubit;
    late MockStackRouter mockStackRouter;

    setUp(() {
      mockMovieListCubit = MockMovieListCubit();
      mockStackRouter = MockStackRouter();
      when(mockMovieListCubit.stream).thenAnswer((_) => Stream.value(const MovieListState.initial()));
      when(mockMovieListCubit.state).thenReturn(const MovieListState.initial());
      when(mockMovieListCubit.searchMovies(any)).thenAnswer((_) async => {});
      getIt.registerFactory<MovieListCubit>(() => mockMovieListCubit);
    });

    tearDown(() {
      getIt.reset();
      mockMovieListCubit.close();
    });

    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: MovieListPage(),
      );
    }

    testWidgets('renders MovieListContent widget', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(MovieListContent), findsOneWidget);
    });

    testWidgets('renders AppBar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Movie Browser'), findsOneWidget);
    });

    testWidgets('renders SearchBox and listens for submit action', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(SearchBox), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Inception');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(mockMovieListCubit.searchMovies(any)).called(1);
    });

    testWidgets('renders MovieListLoader initially', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(MovieListLoader), findsOneWidget);
    });

    testWidgets('MovieListView displays movies when state is Data', (WidgetTester tester) async {
      List<Movie> testMovies = [const Movie(id: 1, title: "Test Movie", voteAverage: 8.0)];
      when(mockMovieListCubit.state).thenReturn(MovieListState.data(testMovies));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(MovieListView), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('80% 🌟'), findsOneWidget);
    });

    testWidgets('displays error message when state is Error', (WidgetTester tester) async {
      const String errorMessage = "Error fetching movies";
      when(mockMovieListCubit.state).thenReturn(const MovieListState.error(errorMessage));
      when(mockMovieListCubit.stream).thenAnswer((_) => Stream.value(const MovieListState.error(errorMessage)));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('displays loading when state is Loading', (WidgetTester tester) async {
      when(mockMovieListCubit.state).thenReturn(const MovieListState.loading());
      when(mockMovieListCubit.stream).thenAnswer((_) => Stream.value(const MovieListState.loading()));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('clicking IconButton does nothing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byIcon(Icons.movie_creation_outlined), findsOneWidget);

      reset(mockMovieListCubit);

      await tester.tap(find.byIcon(Icons.movie_creation_outlined));

      verifyZeroInteractions(mockMovieListCubit);
    });

    testWidgets('navigates to MovieDetailsRoute on tap', (WidgetTester tester) async {
      List<Movie> testMovies = [const Movie(id: 1, title: "Test Movie", voteAverage: 8.0)];
      when(mockMovieListCubit.state).thenReturn(MovieListState.data(testMovies));
      when(mockStackRouter.push(any)).thenAnswer((_) async => null);

      await tester.pumpWidget(
        StackRouterScope(controller: mockStackRouter, stateHash: 0, child: createWidgetUnderTest()),
      );

      await tester.tap(find.byType(MovieCard).at(0));
      await tester.pumpAndSettle();

      verify(mockStackRouter.push(any)).called(1);
    });

    testWidgets('verifies separator properties', (WidgetTester tester) async {
      List<Movie> testMovies = [
        const Movie(id: 1, title: "Test Movie", voteAverage: 8.0),
        const Movie(id: 2, title: "Test Movie 2", voteAverage: 7.0),
      ];
      when(mockMovieListCubit.state).thenReturn(MovieListState.data(testMovies));

      await tester.pumpWidget(createWidgetUnderTest());

      final finder = find.byType(ListSeparator);

      expect(finder, findsAtLeast(1));
    });
  });
}
