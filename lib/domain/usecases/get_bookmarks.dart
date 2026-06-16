import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetBookmarks {
  final NewsRepository repository;

  GetBookmarks(this.repository);

  List<Article> call() {
    return repository.getBookmarks();
  }
}
