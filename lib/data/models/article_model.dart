import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    super.titleHi,
    required super.slug,
    required super.excerpt,
    super.excerptHi,
    required super.content,
    super.imageUrl,
    super.webpUrl,
    super.imageWidth,
    super.imageHeight,
    super.imageAlt,
    required super.author,
    required super.category,
    super.categoryHi,
    super.categoryColor,
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
    String? categoryHi;
    String categorySlug = '';
    String categoryColor = '#c0392b';
    final catJson = json['category'];
    if (catJson is Map) {
      category = catJson['name']?.toString() ?? '';
      categoryHi = catJson['name_hi']?.toString();
      categorySlug = catJson['slug']?.toString() ?? '';
      categoryColor = catJson['color']?.toString() ?? '#c0392b';
    } else if (catJson is String) {
      category = catJson;
      categorySlug = json['category_slug']?.toString() ?? '';
    }

    // Image is returned as nested object {url, thumb, alt, width, height}
    final imageMap = json['image'] as Map?;

    return ArticleModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      titleHi: json['title_hi']?.toString(),
      slug: json['slug']?.toString() ?? '',
      excerpt: json['excerpt']?.toString() ?? '',
      excerptHi: json['excerpt_hi']?.toString(),
      content: json['content']?.toString() ?? '',
      imageUrl: imageMap?['url']?.toString(),
      webpUrl: imageMap?['thumb']?.toString(),
      imageWidth: (imageMap?['width'] as num?)?.toInt() ?? 1200,
      imageHeight: (imageMap?['height'] as num?)?.toInt() ?? 630,
      imageAlt: imageMap?['alt']?.toString(),
      author: json['author']?.toString() ?? '',
      category: category,
      categoryHi: categoryHi,
      categoryColor: categoryColor,
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
        'title_hi': titleHi,
        'slug': slug,
        'excerpt': excerpt,
        'excerpt_hi': excerptHi,
        'content': content,
        'image': {
          'url': imageUrl,
          'thumb': webpUrl,
          'width': imageWidth,
          'height': imageHeight,
          'alt': imageAlt,
        },
        'author': author,
        'category': {
          'name': category,
          'name_hi': categoryHi,
          'slug': categorySlug,
          'color': categoryColor,
        },
        'tags': tags,
        'published_at': publishedAt.toIso8601String(),
        'views': views,
        'related': related
            .map((a) => (a as ArticleModel).toJson())
            .toList(),
      };
}
