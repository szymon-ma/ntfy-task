import 'package:bloc/bloc.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'movie_details_state.dart';

part 'movie_details_cubit.freezed.dart';

@injectable
class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit(this.apiService, @factoryParam this.movie) : super(const MovieDetailsState.loading());

  final Movie movie;
  final ApiService apiService;

  Future<void> fetchMovieDetails() async {
    final movieDetails = await apiService.getMovieDetails(movie.id);
    emit(MovieDetailsState.data(movieDetails, _shouldWatchIt(movieDetails)));
  }

  bool _shouldWatchIt(MovieDetails movieDetails) => _isSundayToday() && _isProfitEnough(movieDetails);

  bool _isSundayToday() {
    final now = DateTime.now();
    return now.weekday == DateTime.sunday;
  }

  bool _isProfitEnough(MovieDetails movieDetails) => movieDetails.revenue - movieDetails.budget > 1000000;
}
