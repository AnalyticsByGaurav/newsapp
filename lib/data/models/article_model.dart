import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.excerpt,
    required super.content,
    super.imageUrl,
    super.webpUrl,
    super.imageWidth,
    super.imageHeight,
    super.imageAlt,
    required super.author,
    required super.category,
    required super.categorySlug,
    super.tags,
    required super.publishedAt,
    super.views,
    super.related,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    // Parse related articles (no nested related inside related)
    final relatedJson = json['related'];
    final List<Article> related;
    if (relatedJson is List) {
      related = relatedJson
          .whereType<Map<String, dynamic>>()
          .map((r) => ArticleModel.fromJson({...r, 'related': []}))
          .toList();
    } else {
      related = [];
    }

    // Parse tags - can be list of strings or list of objects
    final tagsJson = json['tags'];
    final List<String> tags;
    if (tagsJson is List) {
      tags = tagsJson.map((t) {
        if (t is String) return t;
        if (t is Map) return t['name']?.toString() ?? '';
        return t.toString();
      }).where((s) => s.isNotEmpty).toList();
    } else {
      tags = [];
    }

    // Parse published_at
    DateTime publishedAt;
    try {
      publishedAt = DateTime.parse(json['published_at']?.toString() ?? '');
    } catch (_) {
      publishedAt = DateTime.now();
    }

    // Handle category - can be string or object
    String category = '';
    String categorySlug = '';
    final catJson = json['category'];
    if (catJson is Map) {
      category = catJson['name']?.toString() ?? '';
      categorySlug = catJson['slug']?.toString() ?? '';
    } else if (catJson is String) {
      category = catJson;
      categorySlug = json['category_slug']?.toString() ?? '';
    }

    return ArticleModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      excerpt: json['excerpt']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      imageUrl: json['img']?.toString(),
      webpUrl: json['webp']?.toString(),
      imageWidth: (json['img_w'] as num?)?.toInt() ?? 1200,
      imageHeight: (json['img_h'] as num?)?.toInt() ?? 630,
      imageAlt: json['alt']?.toString(),
      author: json['author']?.toString() ?? '',
      category: category,
      categorySlug: categorySlug,
      tags: tags,
      publishedAt: publishedAt,
      views: (json['views'] as num?)?.toInt() ?? 0,
      related: related,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'excerpt': excerpt,
        'content': content,
        'img': imageUrl,
        'webp': webpUrl,
        'img_w': imageWidth,
        'img_h': imageHeight,
        'alt': imageAlt,
        'author': author,
        'category': category,
        'category_slug': categorySlug,
        'tags': tags,
        'published_at': publishedAt.toIso8601String(),
        'views': views,
        'related': related
            .map((a) => (a as ArticleModel).toJson())
            .toList(),
      };
}
