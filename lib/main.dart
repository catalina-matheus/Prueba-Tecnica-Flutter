import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_technical_test_catalina/config/router/app_router.dart';
import 'package:flutter_technical_test_catalina/config/theme/app_theme.dart';
import 'package:flutter_technical_test_catalina/config/theme/cubit/theme_cubit.dart';
import 'package:flutter_technical_test_catalina/infrastructure/datasources/tmdb_remote_datasource.dart';
import 'package:flutter_technical_test_catalina/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/home/home_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final TMDBRemoteDataSource remoteDataSource = TMDBRemoteDataSource();
  final movieRepository = MovieRepositoryImpl(remoteDataSource);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieRepositoryImpl>.value(value: movieRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(
            create: (context) =>
                HomeBloc(movieRepository: movieRepository)..add(FetchMovies()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeModeState>(
      builder: (context, themeState) {
        final bool isDarkMode = themeState == ThemeModeState.dark;

        return MaterialApp.router(
          title: 'Movie App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ).getTheme,
          routerConfig: appRouter,
        );
      },
    );
  }
}
