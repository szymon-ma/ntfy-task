part of 'movie_list_cubit.dart';

@freezed
class MovieListState with _$MovieListState {
  const factory MovieListState.initial() = Initial;

  const factory MovieListState.loading() = Loading;

  const factory MovieListState.data(List<Movie> movies) = Data;

  const factory MovieListState.error(String error) = Error;
}
