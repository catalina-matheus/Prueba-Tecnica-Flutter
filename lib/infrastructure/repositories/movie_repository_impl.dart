import 'package:dio/dio.dart';
import 'package:flutter_technical_test_catalina/config/constants/environment.dart';
import 'package:flutter_technical_test_catalina/domain/entities/actor.dart';
import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';
import 'package:flutter_technical_test_catalina/infrastructure/datasources/tmdb_remote_datasource.dart';
import 'package:flutter_technical_test_catalina/infrastructure/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TMDBRemoteDataSource dataSources;

  MovieRepositoryImpl(this.dataSources);

  @override
  Future<Actor> getActorById(int actorId) async {
    try {
      final response = await dataSources.dio.get(
        '/person/${actorId.toString()}',
        queryParameters: {'append_to_response': 'movie_credits'},
      );

      final actorData = response.data;

      final actor = Actor(
        id: actorData['id'],
        name: actorData['name'] ?? 'Unknown',
        profilePath: actorData['profile_path'] ?? '',
        character: 'Not Available',
        description: (actorData['biography'] != null &&
                actorData['biography'].isNotEmpty)
            ? actorData['biography']
            : 'No biography available.',
      );

      return actor;
    } catch (e) {
      throw Exception("Error fetching actor details");
    }
  }

  @override
  Future<List<Movie>> getMoviesByActorId(int actorId) async {
    try {
      final response = await dataSources.dio
          .get('/person/${actorId.toString()}/movie_credits');

      if (response.statusCode == 200) {
        return (response.data['cast'] as List)
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      }
      throw Exception("Error fetching movies for actor");
    } catch (e) {
      throw Exception("Error fetching movies for actor: $e");
    }
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      final response = await dataSources.dio
          .get('/movie/now_playing', queryParameters: {'page': page});

      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      }
      throw Exception("Error fetching now playing movies");
    } catch (e) {
      throw Exception("Error fetching now playing movies: $e");
    }
  }

  @override
  Future<Movie> getMovieById(String id) async {
    try {
      final response = await dataSources.dio.get('/movie/$id',
          queryParameters: {'append_to_response': 'credits'});

      Movie movie = Movie.fromJson(response.data);

      if (response.data['credits'] == null) {
        final creditsResponse = await dataSources.dio.get('/movie/$id/credits');
        movie.cast = (creditsResponse.data['cast'] as List<dynamic>?)
                ?.map((actorJson) => Actor.fromJson(actorJson))
                .toList() ??
            [];
      } else {
        movie.cast = (response.data['credits']['cast'] as List<dynamic>?)
                ?.map((actorJson) => Actor.fromJson(actorJson))
                .toList() ??
            [];
      }

      return movie;
    } catch (e) {
      throw Exception("Error fetching movie details");
    }
  }

  @override
  Future<List<Movie>> getPopular() async {
    try {
      final response = await dataSources.dio.get('/movie/popular');

      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      }
      throw Exception("Error fetching popular movies");
    } catch (e) {
      throw Exception("Error fetching popular movies: $e");
    }
  }

  @override
  Future<List<Movie>> getTopRated() async {
    try {
      final response = await dataSources.dio.get('/movie/top_rated');

      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      }
      throw Exception("Error fetching top-rated movies");
    } catch (e) {
      throw Exception("Error fetching top-rated movies: $e");
    }
  }

  @override
  Future<List<Movie>> getUpcoming() async {
    try {
      final response = await dataSources.dio.get('/movie/upcoming');

      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      }
      throw Exception("Error fetching upcoming movies");
    } catch (e) {
      throw Exception("Error fetching upcoming movies: $e");
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await dataSources.dio
          .get('/search/movie', queryParameters: {'query': query});

      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      }
      throw Exception("Error searching movies");
    } catch (e) {
      throw Exception("Error searching movies: $e");
    }
  }
}
