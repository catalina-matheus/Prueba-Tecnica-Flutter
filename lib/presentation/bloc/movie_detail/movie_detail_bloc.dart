import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';
import 'package:flutter_technical_test_catalina/infrastructure/repositories/movie_repository_impl.dart';

import 'package:flutter_technical_test_catalina/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/movie_detail/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieRepositoryImpl movieRepository;

  MovieDetailBloc({required this.movieRepository})
      : super(MovieDetailInitial()) {
    on<FetchMovieById>(_onFetchMovieById);
  }

  Future<void> _onFetchMovieById(
      FetchMovieById event, Emitter<MovieDetailState> emit) async {
    emit(MovieDetailLoading());

    try {
      final Movie movie = await movieRepository.getMovieById(event.id);

      emit(MovieDetailLoaded(movie));
    } catch (e) {
      emit(MovieDetailError("Error fetching movie details: $e"));
    }
  }
}
