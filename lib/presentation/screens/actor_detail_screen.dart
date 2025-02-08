import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/actor_detail/actor_bloc.dart';
import 'package:flutter_technical_test_catalina/presentation/bloc/actor_detail/actor_state.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart' as customWidgets;
import '../../config/theme/app_theme.dart';

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
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen circular del actor
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${state.actor.profilePath}'),
                          ),
                          const SizedBox(width: 12),
                          // Nombre del actor  y descripción
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.actor.name,
                                  style: appTheme.getTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ExpandableText(
                                  text: state.actor.description,
                                  maxWords: 40,
                                  textStyle:
                                      appTheme.getTheme.textTheme.bodyMedium!,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Casted on",
                        style: appTheme.getTheme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.movies.length,
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return customWidgets.UniversalCard(
                            title: movie.title,
                            subtitle:
                                "${(movie.voteAverage * 10).toInt()}% User Score",
                            imageUrl: movie.posterPath.isNotEmpty
                                ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                                : "https://cdn-icons-png.flaticon.com/512/3938/3938627.png",
                            onTap: () => context.push('/detail/${movie.id}'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ActorError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No data"));
        },
      ),
    );
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
