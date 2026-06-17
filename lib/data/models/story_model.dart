import '../../domain/entities/story.dart';

class WebStoryModel extends WebStory {
  const WebStoryModel({
    required super.id,
    required super.title,
    required super.slug,
    super.thumbnail,
    super.slidesCount,
  });

  factory WebStoryModel.fromJson(Map<String, dynamic> json) {
    return WebStoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      thumbnail: (json['cover_image'] ?? json['thumbnail'])?.toString(),
      slidesCount: (json['slides_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'thumbnail': thumbnail,
        'slides_count': slidesCount,
      };
}
