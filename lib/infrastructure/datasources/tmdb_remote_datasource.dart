import 'package:dio/dio.dart';
import 'package:flutter_technical_test_catalina/config/constants/environment.dart';

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
}
