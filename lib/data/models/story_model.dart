import '../../domain/entities/story.dart';

class StorySlideModel extends StorySlide {
  const StorySlideModel({
    required super.id,
    super.imgUrl,
    super.bgColor,
    super.bgGradient,
    super.textHi,
    super.textEn,
    super.textPosition,
    super.textColor,
    super.ctaText,
    super.ctaUrl,
    super.ctaColor,
    super.duration,
  });

  factory StorySlideModel.fromJson(Map<String, dynamic> json) {
    return StorySlideModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      imgUrl: json['img_url']?.toString(),
      bgColor: json['bg_color']?.toString() ?? '#1a1208',
      bgGradient: json['bg_gradient']?.toString(),
      textHi: json['text_hi']?.toString(),
      textEn: json['text_en']?.toString(),
      textPosition: json['text_position']?.toString() ?? 'bottom',
      textColor: json['text_color']?.toString() ?? '#ffffff',
      ctaText: json['cta_text']?.toString(),
      ctaUrl: json['cta_url']?.toString(),
      ctaColor: json['cta_color']?.toString() ?? '#c0392b',
      duration: (json['duration'] as num?)?.toInt() ?? 5,
    );
  }
}

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
    super.slides,
  });

  factory WebStoryModel.fromJson(Map<String, dynamic> json) {
    DateTime? publishedAt;
    try {
      final raw = json['published_at']?.toString();
      if (raw != null) publishedAt = DateTime.parse(raw);
    } catch (_) {}

    final slidesList = (json['slides'] as List?)
        ?.map((s) => StorySlideModel.fromJson(s as Map<String, dynamic>))
        .toList() ?? [];

    return WebStoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      titleHi: json['title_hi']?.toString(),
      slug: json['slug']?.toString() ?? '',
      thumbnail: (json['cover_image'] ?? json['thumbnail'] ?? json['cover_url'])?.toString(),
      slidesCount: (json['slides_count'] as num?)?.toInt() ?? slidesList.length,
      views: (json['views'] as num?)?.toInt() ?? 0,
      publishedAt: publishedAt,
      slides: slidesList,
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
