import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_cubit.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_cubit_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MovieListCubit cubit;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    cubit = MovieListCubit(mockApiService);
  });

  tearDown(() {
    cubit.close();
  });

  blocTest<MovieListCubit, MovieListState>(
    'emits [loading, data] when searchMovies is successful',
    build: () => cubit,
    setUp: () {
      when(mockApiService.searchMovies('query')).thenAnswer(
        (_) async => Right(
          List.of(
            [
              const Movie(id: 1, title: 'Movie 1', voteAverage: 8.0),
              const Movie(id: 2, title: 'Movie 2', voteAverage: 7.0),
            ],
          ),
        ),
      );
    },
    act: (cubit) async {
      await cubit.searchMovies('query');
    },
    expect: () => [
      const MovieListState.loading(),
      const MovieListState.data(
        [
          Movie(id: 1, title: 'Movie 1', voteAverage: 8.0),
          Movie(id: 2, title: 'Movie 2', voteAverage: 7.0),
        ],
      ),
    ],
  );

  blocTest<MovieListCubit, MovieListState>(
    'emits [loading, error] when searchMovies fails',
    build: () => cubit,
    setUp: () {
      when(mockApiService.searchMovies('query')).thenAnswer(
        (_) async => const Left('Error message'),
      );
    },
    act: (cubit) async {
      await cubit.searchMovies('query');
    },
    expect: () => [
      const MovieListState.loading(),
      const MovieListState.error('Error message'),
    ],
  );

  blocTest<MovieListCubit, MovieListState>(
    'does not emit any state when query is null or empty',
    build: () => cubit,
    act: (cubit) async {
      await cubit.searchMovies(null);
      await cubit.searchMovies('');
    },
    expect: () => [],
  );
}
