import 'package:flutter_recruitment_task/injectable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_cubit.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';

import 'movie_details_page_test.mocks.dart';

@GenerateMocks([MovieDetailsCubit])
void main() {
  group('MovieDetailsPage', () {
    late MockMovieDetailsCubit mockMovieDetailsCubit;
    late Movie testMovie;

    setUp(() {
      mockMovieDetailsCubit = MockMovieDetailsCubit();
      testMovie = const Movie(id: 1, title: "Inception", voteAverage: 8.5);
      when(mockMovieDetailsCubit.state).thenReturn(const MovieDetailsState.loading());
      when(mockMovieDetailsCubit.stream).thenAnswer((_) => Stream.value(const MovieDetailsState.loading()));
      getIt.registerFactory<MovieDetailsCubit>(() => mockMovieDetailsCubit);
    });

    tearDown(() {
      getIt.reset();
      mockMovieDetailsCubit.close();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: MovieDetailsPage(movie: testMovie),
      );
    }

    testWidgets('renders MovieDetailsLoader initially', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(MovieDetailsLoader), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays the movie title in the AppBar when data is loaded', (WidgetTester tester) async {
      when(mockMovieDetailsCubit.state).thenReturn(const MovieDetailsState.data(
          MovieDetails(title: "Inception", budget: 160000000, revenue: 825532764),
          true
      ));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Inception'), findsOneWidget);
    });

    testWidgets('displays error message when state is Error', (WidgetTester tester) async {
      const String errorMessage = "Failed to fetch details";
      when(mockMovieDetailsCubit.state).thenReturn(const MovieDetailsState.error(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('MovieDetailsContent shows the correct data', (WidgetTester tester) async {
      const movieDetails = MovieDetails(title: "Inception", budget: 160000000, revenue: 825532764);
      when(mockMovieDetailsCubit.state).thenReturn(const MovieDetailsState.data(movieDetails, true));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Budget'), findsOneWidget);
      expect(find.text('\$160,000,000.00'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('\$825,532,764.00'), findsOneWidget);
      expect(find.text('Should I watch it today?'), findsOneWidget);
      expect(find.text('Yes!'), findsOneWidget);
    });
  });
}
