import '../entities/article.dart';
import '../entities/pagination_meta.dart';
import '../repositories/news_repository.dart';

class SearchArticlesParams {
  final String query;
  final int page;

  const SearchArticlesParams({required this.query, this.page = 1});
}

class SearchArticles {
  final NewsRepository repository;

  SearchArticles(this.repository);

  Future<(List<Article>, PaginationMeta)> call(SearchArticlesParams params) {
    return repository.searchArticles(params.query, page: params.page);
  }
}
