import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetRelatedArticles {
  final NewsRepository repository;

  GetRelatedArticles(this.repository);

  Future<List<Article>> call(String slug) {
    return repository.getRelatedArticles(slug);
  }
}
