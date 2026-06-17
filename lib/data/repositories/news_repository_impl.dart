import '../../core/errors/exceptions.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/short.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/site_settings.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/pagination_meta.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/local/news_local_datasource.dart';
import '../datasources/remote/news_remote_datasource.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remote;
  final NewsLocalDataSource _local;

  NewsRepositoryImpl({
    required NewsRemoteDataSource remote,
    required NewsLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<(List<Article>, PaginationMeta)> getLatestNews({
    int page = 1,
    int perPage = 15,
    String? categorySlug,
  }) async {
    final cacheKey = 'news_${categorySlug ?? 'all'}_p$page';
    try {
      final (articles, meta) = await _remote.getLatestNews(
        page: page,
        perPage: perPage,
        categorySlug: categorySlug,
      );
      if (page == 1) {
        await _local.cacheArticles(articles, cacheKey: cacheKey);
      }
      return (articles as List<Article>, meta);
    } catch (e) {
      if (page == 1) {
        final cached = _local.getCachedArticles(cacheKey: cacheKey);
        if (cached != null) {
          return (
            cached as List<Article>,
            const PaginationMeta(page: 1, perPage: 15, total: 0),
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categories = await _remote.getCategories();
      await _local.cacheCategories(categories);
      return categories;
    } catch (e) {
      final cached = _local.getCachedCategories();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<Article> getArticle(String slug) async {
    try {
      final article = await _remote.getArticle(slug);
      await _local.cacheArticle(article);
      return article;
    } catch (e) {
      final cached = _local.getCachedArticle(slug);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<(List<Article>, PaginationMeta)> searchArticles(
    String query, {
    int page = 1,
  }) async {
    final (articles, meta) = await _remote.searchArticles(query, page: page);
    return (articles as List<Article>, meta);
  }

  @override
  Future<List<Article>> getRelatedArticles(String slug) async {
    try {
      return await _remote.getRelatedArticles(slug);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<(List<WebStory>, PaginationMeta)> getWebStories({
    int page = 1,
  }) async {
    try {
      final (stories, meta) = await _remote.getWebStories(page: page);
      if (page == 1) await _local.cacheWebStories(stories);
      return (stories as List<WebStory>, meta);
    } catch (e) {
      if (page == 1) {
        final cached = _local.getCachedWebStories();
        if (cached != null) {
          return (
            cached as List<WebStory>,
            const PaginationMeta(page: 1, perPage: 15, total: 0),
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<WebStory> getStoryDetail(String slug) async {
    return await _remote.getStoryDetail(slug);
  }

  @override
  Future<(List<ShortVideo>, PaginationMeta)> getShorts({int page = 1}) async {
    try {
      final (shorts, meta) = await _remote.getShorts(page: page);
      if (page == 1) await _local.cacheShorts(shorts);
      return (shorts as List<ShortVideo>, meta);
    } catch (e) {
      if (page == 1) {
        final cached = _local.getCachedShorts();
        if (cached != null) {
          return (
            cached as List<ShortVideo>,
            const PaginationMeta(page: 1, perPage: 15, total: 0),
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<SiteSettings> getSettings() async {
    try {
      final settings = await _remote.getSettings();
      await _local.cacheSettings(settings);
      return settings;
    } catch (e) {
      final cached = _local.getCachedSettings();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<void> postComment(CommentRequest request) async {
    await _remote.postComment(request);
  }

  @override
  Future<({String question, String token})> getCaptcha() async {
    return await _remote.getCaptcha();
  }

  @override
  Future<void> saveBookmark(Article article) async {
    await _local.saveBookmark(article as ArticleModel);
  }

  @override
  Future<void> removeBookmark(String slug) async {
    await _local.removeBookmark(slug);
  }

  @override
  List<Article> getBookmarks() {
    return _local.getBookmarks();
  }

  @override
  bool isBookmarked(String slug) {
    return _local.isBookmarked(slug);
  }
}
