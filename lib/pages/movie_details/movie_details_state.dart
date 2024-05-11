part of 'movie_details_cubit.dart';

@freezed
class MovieDetailsState with _$MovieDetailsState {
  const factory MovieDetailsState.initial() = Initial;

  const factory MovieDetailsState.loading() = Loading;

  const factory MovieDetailsState.data(MovieDetails movieDetails, bool shouldWatchIt) = Data;
}
