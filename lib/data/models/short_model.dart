import '../../domain/entities/short.dart';

class ShortVideoModel extends ShortVideo {
  const ShortVideoModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.videoUrl,
    super.thumbnail,
    super.duration,
  });

  factory ShortVideoModel.fromJson(Map<String, dynamic> json) {
    return ShortVideoModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      videoUrl: json['video_url']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      duration: (json['duration'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'video_url': videoUrl,
        'thumbnail': thumbnail,
        'duration': duration,
      };
}
