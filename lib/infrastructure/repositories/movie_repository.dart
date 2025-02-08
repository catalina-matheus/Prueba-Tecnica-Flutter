import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';
import 'package:flutter_technical_test_catalina/domain/entities/actor.dart';

abstract class MovieRepository {
  // Métodos para películas
  Future<List<Movie>> getNowPlaying({required int page});
  Future<List<Movie>> getPopular();
  Future<List<Movie>> getTopRated();
  Future<List<Movie>> getUpcoming();
  Future<Movie> getMovieById(String id);
  Future<List<Movie>> searchMovies(String query);

  //  Métodos para actores
  Future<Actor> getActorById(int actorId);
  Future<List<Movie>> getMoviesByActorId(int actorId);
}
