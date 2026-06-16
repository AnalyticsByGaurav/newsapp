import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();
  @override
  List<Object?> get props => [];
}

class LoadArticleEvent extends ArticleEvent {
  final String slug;
  const LoadArticleEvent({required this.slug});
  @override
  List<Object?> get props => [slug];
}

class ToggleArticleBookmarkEvent extends ArticleEvent {
  const ToggleArticleBookmarkEvent();
}
