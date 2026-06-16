import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final int id;
  final String title;
  final String? titleHi;
  final String slug;
  final String excerpt;
  final String? excerptHi;
  final String content;
  final String? imageUrl;
  final String? webpUrl;
  final int imageWidth;
  final int imageHeight;
  final String? imageAlt;
  final String author;
  final String category;
  final String? categoryHi;
  final String categoryColor;
  final String categorySlug;
  final List<String> tags;
  final DateTime publishedAt;
  final int views;
  final List<Article> related;

  const Article({
    required this.id,
    required this.title,
    this.titleHi,
    required this.slug,
    required this.excerpt,
    this.excerptHi,
    required this.content,
    this.imageUrl,
    this.webpUrl,
    this.imageWidth = 1200,
    this.imageHeight = 630,
    this.imageAlt,
    required this.author,
    required this.category,
    this.categoryHi,
    this.categoryColor = '#c0392b',
    required this.categorySlug,
    this.tags = const [],
    required this.publishedAt,
    this.views = 0,
    this.related = const [],
  });

  String get displayTitle => titleHi?.isNotEmpty == true ? titleHi! : title;
  String get displayExcerpt => excerptHi?.isNotEmpty == true ? excerptHi! : excerpt;

  @override
  List<Object?> get props => [id, slug];
}
