import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/models/movie_list.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract class ApiService {
  Future<Either<String, List<Movie>>> searchMovies(String query);

  Future<Either<String, MovieDetails>> getMovieDetails(int movieId);
}

@Injectable(as: ApiService)
class ApiServiceImpl implements ApiService {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const baseUrl = 'api.themoviedb.org';

  @override
  Future<Either<String, List<Movie>>> searchMovies(String query) async {
    try {
      final parameters = {
        'api_key': apiKey,
        'query': query,
      };

      final endpoint = Uri.https(baseUrl, '/3/search/movie', parameters);

      final response = await http.get(endpoint);
      final json = jsonDecode(response.body);
      final movieList = MovieList.fromJson(json);

      return right(movieList.results);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, MovieDetails>> getMovieDetails(int movieId) async {
    try {
      final parameters = {
        'api_key': apiKey,
      };

      final endpoint = Uri.https(baseUrl, '/3/movie/$movieId', parameters);

      final response = await http.get(endpoint);
      final json = jsonDecode(response.body);
      final movieDetails = MovieDetails.fromJson(json);
      return right(movieDetails);
    } catch (e) {
      return left(e.toString());
    }
  }
}
