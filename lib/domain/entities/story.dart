import 'package:equatable/equatable.dart';

class WebStory extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String? thumbnail;
  final int slidesCount;

  const WebStory({
    required this.id,
    required this.title,
    required this.slug,
    this.thumbnail,
    this.slidesCount = 0,
  });

  @override
  List<Object?> get props => [id, slug];
}
