import 'package:equatable/equatable.dart';

class ShortVideo extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String videoUrl;
  final String? thumbnail;
  final int? duration;

  const ShortVideo({
    required this.id,
    required this.title,
    required this.slug,
    required this.videoUrl,
    this.thumbnail,
    this.duration,
  });

  @override
  List<Object?> get props => [id, slug];
}
