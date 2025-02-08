abstract class ActorEvent {}

class FetchActorById extends ActorEvent {
  final int actorId;

  FetchActorById(this.actorId);
}
