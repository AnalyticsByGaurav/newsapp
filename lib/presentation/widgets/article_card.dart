import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/article.dart';
import 'loading_widget.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool isLarge;

  const ArticleCard({super.key, required this.article, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push('/article/${article.slug}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 75,
                child: article.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: article.webpUrl ?? article.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ShimmerBox(width: 100, height: 75),
                        errorWidget: (_, __, ___) => Container(
                          color: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      )
                    : Container(
                        color: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.article_outlined,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.category.isNotEmpty)
                    Text(
                      article.categoryHi?.isNotEmpty == true
                          ? article.categoryHi!
                          : article.category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    article.displayTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        TimeAgoHelper.format(article.publishedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
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

class ArticleCardLarge extends StatelessWidget {
  final Article article;

  const ArticleCardLarge({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push('/article/${article.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (article.imageUrl != null)
                  CachedNetworkImage(
                    imageUrl: article.webpUrl ?? article.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerBox(width: double.infinity, height: 200),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.colorScheme.primaryContainer,
                    ),
                  )
                else
                  Container(color: theme.colorScheme.primaryContainer),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article.categoryHi?.isNotEmpty == true
                                ? article.categoryHi!
                                : article.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSansDevanagari',
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        article.displayTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansDevanagari',
                          shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(article.author, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  TimeAgoHelper.format(article.publishedAt),
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
