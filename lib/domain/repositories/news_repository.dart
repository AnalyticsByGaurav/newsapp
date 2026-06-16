import '../entities/article.dart';
import '../entities/category.dart';
import '../entities/short.dart';
import '../entities/story.dart';
import '../entities/site_settings.dart';
import '../entities/comment.dart';
import '../entities/pagination_meta.dart';

abstract class NewsRepository {
  Future<(List<Article>, PaginationMeta)> getLatestNews({
    int page = 1,
    int perPage = 15,
    String? categorySlug,
  });

  Future<List<Category>> getCategories();

  Future<Article> getArticle(String slug);

  Future<(List<Article>, PaginationMeta)> searchArticles(
    String query, {
    int page = 1,
  });

  Future<List<Article>> getRelatedArticles(String slug);

  Future<(List<WebStory>, PaginationMeta)> getWebStories({int page = 1});

  Future<(List<ShortVideo>, PaginationMeta)> getShorts({int page = 1});

  Future<SiteSettings> getSettings();

  Future<void> postComment(CommentRequest request);

  Future<({String question, String token})> getCaptcha();

  Future<void> saveBookmark(Article article);

  Future<void> removeBookmark(String slug);

  List<Article> getBookmarks();

  bool isBookmarked(String slug);
}
