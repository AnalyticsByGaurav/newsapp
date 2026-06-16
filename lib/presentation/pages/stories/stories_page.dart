import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/web_stories/web_stories_bloc.dart';
import '../../blocs/web_stories/web_stories_event.dart';
import '../../blocs/web_stories/web_stories_state.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../../domain/entities/story.dart';

class WebStoriesPage extends StatelessWidget {
  const WebStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('वेब स्टोरीज़')),
      body: BlocBuilder<WebStoriesBloc, WebStoriesState>(
        builder: (context, state) {
          if (state is WebStoriesLoading) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.6,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 200),
            );
          }
          if (state is WebStoriesError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<WebStoriesBloc>().add(const LoadWebStoriesEvent()),
            );
          }
          if (state is WebStoriesLoaded) {
            if (state.stories.isEmpty) {
              return const AppEmptyWidget(
                message: 'कोई स्टोरी उपलब्ध नहीं है।',
                icon: Icons.auto_stories_outlined,
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.6,
              ),
              itemCount: state.stories.length,
              itemBuilder: (context, index) {
                return _StoryCard(story: state.stories[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final WebStory story;

  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/story/${story.slug}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (story.thumbnail != null)
              CachedNetworkImage(
                imageUrl: story.thumbnail!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: Colors.grey[300]),
              )
            else
              Container(
                color: const Color(0xFFE53935),
                child: const Icon(Icons.auto_stories, color: Colors.white, size: 48),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansDevanagari',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${story.slidesCount} स्लाइड',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
