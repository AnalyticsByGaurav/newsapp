import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class BookmarksState extends Equatable {
  const BookmarksState();
  @override
  List<Object?> get props => [];
}

class BookmarksInitial extends BookmarksState {
  const BookmarksInitial();
}

class BookmarksLoaded extends BookmarksState {
  final List<Article> bookmarks;

  const BookmarksLoaded({required this.bookmarks});

  @override
  List<Object?> get props => [bookmarks];
}
