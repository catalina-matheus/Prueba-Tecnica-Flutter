import '../../../domain/entities/movie.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final List<Movie> movies;
  HomeLoading(this.movies);
}

class HomeLoaded extends HomeState {
  final List<Movie> movies;
  final bool hasMore;
  HomeLoaded(this.movies, {required this.hasMore});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
