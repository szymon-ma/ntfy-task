import 'package:dartz/dartz.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late ApiServiceImpl apiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient((request) async {
      if (request.url.path == '/3/search/movie') {
        return http.Response(
          '{"results": [{"id": 1, "title": "Test Movie", "vote_average": 0.90}], "total_results": 100}',
          200,
        );
      } else if (request.url.path == '/3/movie/1') {
        return http.Response(
          '{"id": 1, "title": "Test Movie Details", "revenue": 1000, "budget": 100}',
          200,
        );
      } else {
        return http.Response('Not Found', 404);
      }
    });
    apiService = ApiServiceImpl(mockClient);
  });

  group('searchMovies', () {
    test('returns a list of movies when successful', () async {
      final result = await apiService.searchMovies('test');
      expect(result, isA<Right>());
      expect((result as Right).value, isA<List<Movie>>());
    });

    test('returns an error when the request fails', () async {
      mockClient = MockClient((_) async => http.Response('Error', 500));
      apiService = ApiServiceImpl(mockClient);

      final result = await apiService.searchMovies('test');
      expect(result, isA<Left>());
    });
  });

  group('getMovieDetails', () {
    test('returns movie details when successful', () async {
      final result = await apiService.getMovieDetails(1);
      expect(result, isA<Right>());
      expect((result as Right).value, isA<MovieDetails>());
    });

    test('returns an error when the request fails', () async {
      mockClient = MockClient((_) async => http.Response('Error', 500));
      apiService = ApiServiceImpl(mockClient);

      final result = await apiService.getMovieDetails(1);
      expect(result, isA<Left>());
    });
  });
}
