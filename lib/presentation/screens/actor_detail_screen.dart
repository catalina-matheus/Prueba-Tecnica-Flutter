import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart' as customWidgets;
import '../../config/theme/app_theme.dart';
import '../bloc/actor_detail/actor_bloc.dart';
import '../bloc/actor_detail/actor_state.dart';

class ActorDetailScreen extends StatelessWidget {
  final int actorId;

  const ActorDetailScreen({super.key, required this.actorId});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(brightness: Theme.of(context).brightness);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: customWidgets.BackButton(),
          ),
        ),
      ),
      body: BlocBuilder<ActorBloc, ActorState>(
        builder: (context, state) {
          if (state is ActorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ActorLoaded) {
            return _buildLoadedState(state, context, appTheme);
          } else if (state is ActorError) {
            return _buildErrorState(state);
          }
          return const Center(child: Text("No data"));
        },
      ),
    );
  }

  Widget _buildLoadedState(
      ActorLoaded state, BuildContext context, AppTheme appTheme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActorInfo(state, context, appTheme),
                const SizedBox(height: 24),
                _buildCastedOnTitle(context, appTheme),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        _buildMoviesGrid(state, context),
      ],
    );
  }

  Widget _buildActorInfo(
      ActorLoaded state, BuildContext context, AppTheme appTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              'https://image.tmdb.org/t/p/w500${state.actor.profilePath}'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.actor.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              ExpandableText(
                text: state.actor.description,
                maxWords: 40,
                textStyle: Theme.of(context).textTheme.bodyMedium!,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCastedOnTitle(BuildContext context, AppTheme appTheme) {
    return Text(
      "Casted on",
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildMoviesGrid(ActorLoaded state, BuildContext context) {
    return SliverToBoxAdapter(
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.movies.length,
        itemBuilder: (context, index) {
          final movie = state.movies[index];
          return Container(
            margin: EdgeInsets.only(top: index % 2 == 0 ? 0 : 30),
            child: SizedBox(
              height: 300, // Ajusta la altura según sea necesario
              child: customWidgets.UniversalCard(
                title: movie.title,
                subtitle: "${(movie.voteAverage * 10).toInt()}% User Score",
                imageUrl: movie.posterPath.isNotEmpty
                    ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                    : "https://cdn-icons-png.flaticon.com/512/3938/3938627.png",
                onTap: () => context.push('/detail/${movie.id}'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(ActorError state) {
    return Center(child: Text(state.message));
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxWords;
  final TextStyle textStyle;

  const ExpandableText({
    required this.text,
    required this.maxWords,
    required this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(' ');
    final displayText = isExpanded
        ? widget.text
        : words.take(widget.maxWords).join(' ') +
            (words.length > widget.maxWords ? '...' : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: widget.textStyle,
          textAlign: TextAlign.left,
        ),
        if (words.length > widget.maxWords)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'Read less' : 'Read more',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
