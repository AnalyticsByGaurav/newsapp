import 'package:equatable/equatable.dart';

class StorySlide extends Equatable {
  final int id;
  final String? imgUrl;
  final String bgColor;
  final String? bgGradient;
  final String? textHi;
  final String? textEn;
  final String textPosition;
  final String textColor;
  final String? ctaText;
  final String? ctaUrl;
  final String ctaColor;
  final int duration;

  const StorySlide({
    required this.id,
    this.imgUrl,
    this.bgColor = '#1a1208',
    this.bgGradient,
    this.textHi,
    this.textEn,
    this.textPosition = 'bottom',
    this.textColor = '#ffffff',
    this.ctaText,
    this.ctaUrl,
    this.ctaColor = '#c0392b',
    this.duration = 5,
  });

  String get displayText => textHi?.isNotEmpty == true ? textHi! : textEn ?? '';

  @override
  List<Object?> get props => [id];
}

class WebStory extends Equatable {
  final int id;
  final String title;
  final String? titleHi;
  final String slug;
  final String? thumbnail;
  final int slidesCount;
  final int views;
  final DateTime? publishedAt;
  final List<StorySlide> slides;

  const WebStory({
    required this.id,
    required this.title,
    this.titleHi,
    required this.slug,
    this.thumbnail,
    this.slidesCount = 0,
    this.views = 0,
    this.publishedAt,
    this.slides = const [],
  });

  String get displayTitle => titleHi?.isNotEmpty == true ? titleHi! : title;

  @override
  List<Object?> get props => [id, slug];
}
