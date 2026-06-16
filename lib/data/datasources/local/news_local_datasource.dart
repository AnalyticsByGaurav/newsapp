import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/cache_manager.dart';
import '../../models/article_model.dart';
import '../../models/category_model.dart';
import '../../models/short_model.dart';
import '../../models/story_model.dart';
import '../../models/site_settings_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheArticles(List<ArticleModel> articles, {String cacheKey});
  List<ArticleModel>? getCachedArticles({String cacheKey});
  Future<void> cacheArticle(ArticleModel article);
  ArticleModel? getCachedArticle(String slug);
  Future<void> cacheCategories(List<CategoryModel> categories);
  List<CategoryModel>? getCachedCategories();
  Future<void> cacheSettings(SiteSettingsModel settings);
  SiteSettingsModel? getCachedSettings();
  Future<void> saveBookmark(ArticleModel article);
  Future<void> removeBookmark(String slug);
  List<ArticleModel> getBookmarks();
  bool isBookmarked(String slug);
  Future<void> cacheWebStories(List<WebStoryModel> stories);
  List<WebStoryModel>? getCachedWebStories();
  Future<void> cacheShorts(List<ShortVideoModel> shorts);
  List<ShortVideoModel>? getCachedShorts();
  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Box _articlesBox;
  final Box _bookmarksBox;
  final Box _settingsBox;
  final CacheManager _cacheManager;

  NewsLocalDataSourceImpl({
    required Box articlesBox,
    required Box bookmarksBox,
    required Box settingsBox,
    required CacheManager cacheManager,
  })  : _articlesBox = articlesBox,
        _bookmarksBox = bookmarksBox,
        _settingsBox = settingsBox,
        _cacheManager = cacheManager;

  @override
  Future<void> cacheArticles(
    List<ArticleModel> articles, {
    String cacheKey = 'news_list',
  }) async {
    try {
      final encoded = articles.map((a) => a.toJson()).toList();
      await _cacheManager.set(
        cacheKey,
        encoded,
        ttlSeconds: AppConstants.newsCacheTtl,
      );
    } catch (e) {
      throw CacheException('Failed to cache articles: $e');
    }
  }

  @override
  List<ArticleModel>? getCachedArticles({String cacheKey = 'news_list'}) {
    try {
      final raw = _cacheManager.get<List>(cacheKey);
      if (raw == null) return null;
      return raw
          .whereType<Map>()
          .map((m) => ArticleModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheArticle(ArticleModel article) async {
    try {
      await _articlesBox.put(
        'article_${article.slug}',
        jsonEncode(article.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache article: $e');
    }
  }

  @override
  ArticleModel? getCachedArticle(String slug) {
    try {
      final raw = _articlesBox.get('article_$slug');
      if (raw == null) return null;
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      return ArticleModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final encoded = categories.map((c) => c.toJson()).toList();
      await _cacheManager.set(
        'categories',
        encoded,
        ttlSeconds: AppConstants.categoryCacheTtl,
      );
    } catch (e) {
      throw CacheException('Failed to cache categories: $e');
    }
  }

  @override
  List<CategoryModel>? getCachedCategories() {
    try {
      final raw = _cacheManager.get<List>('categories');
      if (raw == null) return null;
      return raw
          .whereType<Map>()
          .map((m) => CategoryModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheSettings(SiteSettingsModel settings) async {
    try {
      await _settingsBox.put('site_settings', jsonEncode(settings.toJson()));
    } catch (e) {
      throw CacheException('Failed to cache settings: $e');
    }
  }

  @override
  SiteSettingsModel? getCachedSettings() {
    try {
      final raw = _settingsBox.get('site_settings');
      if (raw == null) return null;
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      return SiteSettingsModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveBookmark(ArticleModel article) async {
    try {
      await _bookmarksBox.put(article.slug, jsonEncode(article.toJson()));
    } catch (e) {
      throw CacheException('Failed to save bookmark: $e');
    }
  }

  @override
  Future<void> removeBookmark(String slug) async {
    try {
      await _bookmarksBox.delete(slug);
    } catch (e) {
      throw CacheException('Failed to remove bookmark: $e');
    }
  }

  @override
  List<ArticleModel> getBookmarks() {
    try {
      final list = <ArticleModel>[];
      for (final key in _bookmarksBox.keys) {
        final raw = _bookmarksBox.get(key);
        if (raw is String) {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          list.add(ArticleModel.fromJson(map));
        }
      }
      return list.reversed.toList();
    } catch (_) {
      return [];
    }
  }

  @override
  bool isBookmarked(String slug) {
    return _bookmarksBox.containsKey(slug);
  }

  @override
  Future<void> cacheWebStories(List<WebStoryModel> stories) async {
    try {
      final encoded = stories.map((s) => s.toJson()).toList();
      await _cacheManager.set(
        'web_stories',
        encoded,
        ttlSeconds: AppConstants.newsCacheTtl,
      );
    } catch (e) {
      throw CacheException('Failed to cache web stories: $e');
    }
  }

  @override
  List<WebStoryModel>? getCachedWebStories() {
    try {
      final raw = _cacheManager.get<List>('web_stories');
      if (raw == null) return null;
      return raw
          .whereType<Map>()
          .map((m) => WebStoryModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheShorts(List<ShortVideoModel> shorts) async {
    try {
      final encoded = shorts.map((s) => s.toJson()).toList();
      await _cacheManager.set(
        'shorts',
        encoded,
        ttlSeconds: AppConstants.newsCacheTtl,
      );
    } catch (e) {
      throw CacheException('Failed to cache shorts: $e');
    }
  }

  @override
  List<ShortVideoModel>? getCachedShorts() {
    try {
      final raw = _cacheManager.get<List>('shorts');
      if (raw == null) return null;
      return raw
          .whereType<Map>()
          .map((m) => ShortVideoModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await _cacheManager.clear();
    await _articlesBox.clear();
  }
}
