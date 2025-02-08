import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get theMovieDbKey =>
      dotenv.env['THE_MOVIE_DB_KEY'] ?? 'API_KEY_NO_ENCONTRADA';
}
