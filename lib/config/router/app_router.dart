import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/actor_detail/actor_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/actor_detail/actor_event.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_technical_test_catalina/presentation/screens/home_screen.dart';
import 'package:flutter_technical_test_catalina/presentation/screens/movie_detail_screen.dart';
import 'package:flutter_technical_test_catalina/presentation/screens/actor_detail_screen.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:flutter_technical_test_catalina/infrastructure/repositories/movie_repository_impl.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detail/:movieId',
      builder: (context, state) {
        final String movieId = state.pathParameters['movieId']!;
        return BlocProvider(
          create: (context) => MovieDetailBloc(
            movieRepository: context.read<MovieRepositoryImpl>(),
          )..add(FetchMovieById(movieId)),
          child: MovieDetailScreen(movieId: movieId),
        );
      },
    ),
    GoRoute(
      path: '/profile/:actorId',
      builder: (context, state) {
        final actorId = int.tryParse(state.pathParameters['actorId']!) ?? 0;
        return BlocProvider(
          create: (context) => ActorBloc(
            movieRepository: context.read<MovieRepositoryImpl>(),
          )..add(FetchActorById(actorId)),
          child: ActorDetailScreen(actorId: actorId),
        );
      },
    ),
  ],
);
