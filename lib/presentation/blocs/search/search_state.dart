import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<Article> articles;
  final String query;
  final bool hasMore;
  final int page;

  const SearchLoaded({
    required this.articles,
    required this.query,
    required this.hasMore,
    required this.page,
  });

  @override
  List<Object?> get props => [articles, query, hasMore, page];
}

class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty({required this.query});
  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({required this.message});
  @override
  List<Object?> get props => [message];
}
