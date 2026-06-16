import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final String? webpUrl;
  final int imageWidth;
  final int imageHeight;
  final String? imageAlt;
  final String author;
  final String category;
  final String categorySlug;
  final List<String> tags;
  final DateTime publishedAt;
  final int views;
  final List<Article> related;

  const Article({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    this.imageUrl,
    this.webpUrl,
    this.imageWidth = 1200,
    this.imageHeight = 630,
    this.imageAlt,
    required this.author,
    required this.category,
    required this.categorySlug,
    this.tags = const [],
    required this.publishedAt,
    this.views = 0,
    this.related = const [],
  });

  @override
  List<Object?> get props => [id, slug];
}
