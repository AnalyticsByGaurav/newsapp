import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookmarksEvent extends BookmarksEvent {
  const LoadBookmarksEvent();
}

class ToggleBookmarkEvent extends BookmarksEvent {
  final Article article;
  const ToggleBookmarkEvent(this.article);
  @override
  List<Object?> get props => [article.slug];
}

class RemoveBookmarkEvent extends BookmarksEvent {
  final String slug;
  const RemoveBookmarkEvent(this.slug);
  @override
  List<Object?> get props => [slug];
}
