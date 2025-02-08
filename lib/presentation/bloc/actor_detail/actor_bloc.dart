import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_test_catalina/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/actor_detail/actor_event.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/actor_detail/actor_state.dart';

class ActorBloc extends Bloc<ActorEvent, ActorState> {
  final MovieRepositoryImpl movieRepository;

  ActorBloc({required this.movieRepository}) : super(ActorInitial()) {
    on<FetchActorById>(_onFetchActorById);
  }

  Future<void> _onFetchActorById(
      FetchActorById event, Emitter<ActorState> emit) async {
    emit(ActorLoading());

    try {
      final actor = await movieRepository.getActorById(event.actorId);
      final movies = await movieRepository.getMoviesByActorId(event.actorId);

      emit(ActorLoaded(actor, movies));
    } catch (e) {
      emit(ActorError("Error fetching actor details: $e"));
    }
  }
}
