import 'package:dio/dio.dart';
import 'package:flutter_technical_test_catalina/config/constants/environment.dart';
import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';

class TMDBRemoteDataSource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer ${Environment.theMovieDbKey}',
        'Accept': 'application/json',
      },
      queryParameters: {
        'language': 'en-US',
      },
    ),
  );

  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      final response =
          await dio.get('/movie/now_playing', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load movies: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("API Request Failed");
    }
  }
}
