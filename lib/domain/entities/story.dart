import 'package:equatable/equatable.dart';

class WebStory extends Equatable {
  final int id;
  final String title;
  final String? titleHi;
  final String slug;
  final String? thumbnail;
  final int slidesCount;
  final int views;
  final DateTime? publishedAt;

  const WebStory({
    required this.id,
    required this.title,
    this.titleHi,
    required this.slug,
    this.thumbnail,
    this.slidesCount = 0,
    this.views = 0,
    this.publishedAt,
  });

  String get displayTitle => titleHi?.isNotEmpty == true ? titleHi! : title;

  @override
  List<Object?> get props => [id, slug];
}
