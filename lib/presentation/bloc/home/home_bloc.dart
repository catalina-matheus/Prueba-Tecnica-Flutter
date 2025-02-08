import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';
import 'package:flutter_technical_test_catalina/infrastructure/repositories/movie_repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository movieRepository;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  HomeBloc({required this.movieRepository}) : super(HomeInitial()) {
    on<FetchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<HomeState> emit) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    final currentMovies =
        state is HomeLoaded ? (state as HomeLoaded).movies : [];

    try {
      final newMovies = await movieRepository.getPopular();

      if (newMovies.isNotEmpty) {
        _currentPage++;
      } else {
        _hasMore = false;
      }

      emit(HomeLoaded(List<Movie>.from(currentMovies + newMovies),
          hasMore: _hasMore));
    } catch (e) {
      emit(HomeError("Error fetching movies: $e"));
    } finally {
      _isLoading = false;
    }
  }
}
