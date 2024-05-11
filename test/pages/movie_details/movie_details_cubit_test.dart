import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_cubit.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_details_cubit_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MovieDetailsCubit cubit;
  late MockApiService mockApiService;
  const testMovie = Movie(id: 1, title: 'Test Movie', voteAverage: 7.5);

  setUp(() {
    mockApiService = MockApiService();
    cubit = MovieDetailsCubit(mockApiService, testMovie);
  });

  tearDown(() {
    cubit.close();
  });

  group(
    'fetchMovieDetails',
    () {
      blocTest<MovieDetailsCubit, MovieDetailsState>(
        'emits [data(shouldWatch: true)] on successful fetch and Sunday',
        build: () => cubit,
        // 2024-05-12 is a Sunday
        act: (cubit) => withClock(Clock.fixed(DateTime(2024, 5, 12)), cubit.fetchMovieDetails),
        expect: () => [
          const MovieDetailsState.data(
            MovieDetails(title: 'Test Movie Details', revenue: 2000000, budget: 500000),
            true,
          ),
        ],
        setUp: () {
          when(mockApiService.getMovieDetails(testMovie.id)).thenAnswer(
            (_) async => const Right(MovieDetails(title: 'Test Movie Details', revenue: 2000000, budget: 500000)),
          );
        },
      );

      blocTest<MovieDetailsCubit, MovieDetailsState>(
        'emits [data(shouldWatch: false)] on successful fetch and not Sunday',
        setUp: () {
          when(mockApiService.getMovieDetails(testMovie.id)).thenAnswer(
            (_) async => const Right(MovieDetails(title: 'Test Movie Details', revenue: 2000000, budget: 500000)),
          );
        },
        build: () => cubit,
        act: (cubit) => withClock(Clock.fixed(DateTime(2024, 5, 11)), cubit.fetchMovieDetails),
        // 2024-05-11 is a Saturday
        expect: () => [
          const MovieDetailsState.data(
            MovieDetails(title: 'Test Movie Details', revenue: 2000000, budget: 500000),
            false,
          ),
        ],
      );

      blocTest<MovieDetailsCubit, MovieDetailsState>(
        'emits [error] on failed fetch',
        setUp: () {
          when(mockApiService.getMovieDetails(testMovie.id)).thenAnswer(
            (_) async => const Left('API Error'),
          );
        },
        build: () => cubit,
        act: (cubit) => cubit.fetchMovieDetails(),
        expect: () => [
          const MovieDetailsState.error('API Error'),
        ],
      );
    },
  );
}
