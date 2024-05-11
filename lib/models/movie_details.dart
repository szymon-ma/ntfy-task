import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_details.freezed.dart';

part 'movie_details.g.dart';

@freezed
class MovieDetails with _$MovieDetails {
  const factory MovieDetails({required String title, required int revenue, required int budget}) = _MovieDetails;

  factory MovieDetails.fromJson(Map<String, dynamic> json) => _$MovieDetailsFromJson(json);
}
