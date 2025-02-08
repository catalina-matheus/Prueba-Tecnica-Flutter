import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';
import 'package:flutter_technical_test_catalina/domain/entities/actor.dart';

abstract class MovieRepository {
  // Métodos para peliculas
  Future<List<Movie>> getPopular();
  Future<Movie> getMovieById(String id);

  //  Métodos para actores
  Future<Actor> getActorById(int actorId);
  Future<List<Movie>> getMoviesByActorId(int actorId);
}
