import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter_technical_test_catalina/domain/entities/movie.dart';
import 'package:flutter_technical_test_catalina/domain/entities/actor.dart';
import 'package:flutter_technical_test_catalina/presentation/widgets/widgets.dart'
    as customWidgets;
import 'package:go_router/go_router.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MovieDetailError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          if (state is MovieDetailLoaded) {
            final Movie movie = state.movie;

            return Stack(
              children: [
                _buildBackgroundImage(movie),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: customWidgets.CloseButton(),
                    ),
                  ),
                ),
                _buildMovieInfo(movie),
              ],
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }

  Widget _buildBackgroundImage(Movie movie) {
    return Positioned.fill(
      child: Image.network(
        "https://image.tmdb.org/t/p/original${movie.posterPath}",
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMovieInfo(Movie movie) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.4),
              Colors.transparent,
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            _buildTitleAndScore(movie),
            const SizedBox(height: 20),
            _buildCastCarousel(movie),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndScore(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "${(movie.voteAverage * 10).toInt()}% User Score",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildCastCarousel(Movie movie) {
    if (movie.cast.isNotEmpty) {
      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: movie.cast.length,
          itemBuilder: (context, index) {
            final Actor actor = movie.cast[index];
            return SizedBox(
              width: 120,
              child: customWidgets.UniversalCard(
                title: actor.name,
                subtitle: actor.character,
                imageUrl: actor.profilePath.isNotEmpty
                    ? "https://image.tmdb.org/t/p/w500${actor.profilePath}"
                    : "https://cdn-icons-png.flaticon.com/512/2815/2815428.png",
                onTap: () => context.push('/profile/${actor.id}'),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No hay actores disponibles",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }
  }
}
