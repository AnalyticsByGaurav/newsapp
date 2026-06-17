import '../../domain/entities/story.dart';

class WebStoryModel extends WebStory {
  const WebStoryModel({
    required super.id,
    required super.title,
    super.titleHi,
    required super.slug,
    super.thumbnail,
    super.slidesCount,
    super.views,
    super.publishedAt,
  });

  factory WebStoryModel.fromJson(Map<String, dynamic> json) {
    DateTime? publishedAt;
    try {
      final raw = json['published_at']?.toString();
      if (raw != null) publishedAt = DateTime.parse(raw);
    } catch (_) {}

    return WebStoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      titleHi: json['title_hi']?.toString(),
      slug: json['slug']?.toString() ?? '',
      thumbnail: (json['cover_image'] ?? json['thumbnail'])?.toString(),
      slidesCount: (json['slides_count'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      publishedAt: publishedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'title_hi': titleHi,
        'slug': slug,
        'cover_image': thumbnail,
        'slides_count': slidesCount,
        'views': views,
        'published_at': publishedAt?.toIso8601String(),
      };
}
