import 'package:flutter_technical_test_catalina/domain/entities/actor.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  List<Actor> cast;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    this.cast = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      cast: (json['credits']?['cast'] as List<dynamic>?)
              ?.map((actorJson) => Actor.fromJson(actorJson))
              .toList() ??
          [],
    );
  }
}
