import 'package:flutter_technical_test_catalina/domain/entities/actor.dart';
import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';

abstract class ActorState {}

class ActorInitial extends ActorState {}

class ActorLoading extends ActorState {}

class ActorLoaded extends ActorState {
  final Actor actor;
  final List<Movie> movies;

  ActorLoaded(this.actor, this.movies);
}

class ActorError extends ActorState {
  final String message;

  ActorError(this.message);
}
