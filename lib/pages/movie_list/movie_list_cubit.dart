import 'package:bloc/bloc.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'movie_list_state.dart';

part 'movie_list_cubit.freezed.dart';

@injectable
class MovieListCubit extends Cubit<MovieListState> {
  final ApiService _apiService;

  MovieListCubit(this._apiService) : super(const MovieListState.initial());

  Future searchMovies(String? query) async {
    emit(const MovieListState.loading());

    if(query == null || query.isEmpty) {
      return;
    }

    final movies = await _apiService.searchMovies(query);
    _sortMovies(movies);
    emit(MovieListState.data(movies));
  }

  void _sortMovies(List<Movie> movies) {
    movies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
  }
}
