import 'package:json_annotation/json_annotation.dart';

part 'movie_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieDetails {
  final String title;
  final int revenue;
  final int budget;

  MovieDetails({
    required this.title,
    required this.revenue,
    required this.budget,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) => _$MovieDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);
}
