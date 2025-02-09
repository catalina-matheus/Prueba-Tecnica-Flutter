import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/app_theme.dart';
import '../../config/theme/cubit/theme_cubit.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final homeBloc = context.read<HomeBloc>();
    final state = homeBloc.state;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (state is HomeLoaded && state.hasMore) {
        homeBloc.add(FetchMovies());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final bool isDarkMode = themeCubit.isDarkMode(context);
    final appTheme =
        AppTheme(brightness: isDarkMode ? Brightness.dark : Brightness.light);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingHorizontal = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: appTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: appTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Latest',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: appTheme.textColor,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: const MenuButton(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial ||
                (state is HomeLoading && state.movies.isEmpty)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return _buildErrorState(state, appTheme);
            }

            if (state is HomeLoaded) {
              return _buildLoadedState(state, context, appTheme, screenWidth);
            }

            return _buildNoMoviesAvailable(appTheme);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(HomeError state, AppTheme appTheme) {
    return Center(
      child: Text(
        "Error: ${state.message}",
        style: TextStyle(color: appTheme.textColor),
      ),
    );
  }

  Widget _buildLoadedState(HomeLoaded state, BuildContext context,
      AppTheme appTheme, double screenWidth) {
    final movies = state.movies;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 100 &&
            state.hasMore) {
          context.read<HomeBloc>().add(FetchMovies());
        }
        return false;
      },
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
            stops: [0.9, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: MasonryGridView.count(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10),
          crossAxisCount: screenWidth > 600 ? 3 : 2,
          itemCount: movies.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == movies.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final movie = movies[index];

            return Container(
              margin: EdgeInsets.only(top: index % 2 == 0 ? 0 : 30),
              child: SizedBox(
                height: 300, // Ajusta la altura según sea necesario
                child: UniversalCard(
                  title: movie.title,
                  subtitle:
                      "${(movie.voteAverage * 10).toStringAsFixed(0)}% User Score",
                  imageUrl: movie.posterPath.isNotEmpty
                      ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                      : "https://cdn-icons-png.flaticon.com/512/3938/3938627.png",
                  onTap: () => context.push('/detail/${movie.id}'),
                ),
              ),
            );
          },
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
        ),
      ),
    );
  }

  Widget _buildNoMoviesAvailable(AppTheme appTheme) {
    return Center(
      child: Text(
        "No movies available",
        style: TextStyle(color: appTheme.textColor),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
