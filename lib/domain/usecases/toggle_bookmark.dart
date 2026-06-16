import '../entities/article.dart';
import '../repositories/news_repository.dart';

class ToggleBookmark {
  final NewsRepository repository;

  ToggleBookmark(this.repository);

  Future<bool> call(Article article) async {
    final isBookmarked = repository.isBookmarked(article.slug);
    if (isBookmarked) {
      await repository.removeBookmark(article.slug);
      return false;
    } else {
      await repository.saveBookmark(article);
      return true;
    }
  }
}
