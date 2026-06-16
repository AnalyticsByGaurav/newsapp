import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends NewsState {
  const HomeInitial();
}

class HomeLoading extends NewsState {
  const HomeLoading();
}

class HomeLoaded extends NewsState {
  final List<Article> articles;
  final bool hasMore;
  final int page;
  final String? categorySlug;

  const HomeLoaded({
    required this.articles,
    required this.hasMore,
    required this.page,
    this.categorySlug,
  });

  HomeLoaded copyWith({
    List<Article>? articles,
    bool? hasMore,
    int? page,
    String? categorySlug,
  }) {
    return HomeLoaded(
      articles: articles ?? this.articles,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      categorySlug: categorySlug ?? this.categorySlug,
    );
  }

  @override
  List<Object?> get props => [articles, hasMore, page, categorySlug];
}

class HomeLoadingMore extends HomeLoaded {
  const HomeLoadingMore({
    required super.articles,
    required super.hasMore,
    required super.page,
    super.categorySlug,
  });
}

class HomeError extends NewsState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
