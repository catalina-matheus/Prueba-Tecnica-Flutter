abstract class MovieDetailEvent {}

class FetchMovieById extends MovieDetailEvent {
  final String id;

  FetchMovieById(this.id);
}
