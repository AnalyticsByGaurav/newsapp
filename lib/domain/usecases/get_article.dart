import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetArticle {
  final NewsRepository repository;

  GetArticle(this.repository);

  Future<Article> call(String slug) {
    return repository.getArticle(slug);
  }
}
