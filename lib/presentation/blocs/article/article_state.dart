import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class ArticleState extends Equatable {
  const ArticleState();
  @override
  List<Object?> get props => [];
}

class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

class ArticleLoading extends ArticleState {
  const ArticleLoading();
}

class ArticleLoaded extends ArticleState {
  final Article article;
  final bool isBookmarked;

  const ArticleLoaded({required this.article, this.isBookmarked = false});

  ArticleLoaded copyWith({Article? article, bool? isBookmarked}) {
    return ArticleLoaded(
      article: article ?? this.article,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [article, isBookmarked];
}

class ArticleError extends ArticleState {
  final String message;
  const ArticleError({required this.message});
  @override
  List<Object?> get props => [message];
}
