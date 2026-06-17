import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../models/article_model.dart';
import '../../models/category_model.dart';
import '../../models/short_model.dart';
import '../../models/story_model.dart';
import '../../models/site_settings_model.dart';
import '../../../domain/entities/pagination_meta.dart';
import '../../../domain/entities/comment.dart';

abstract class NewsRemoteDataSource {
  Future<(List<ArticleModel>, PaginationMeta)> getLatestNews({
    int page,
    int perPage,
    String? categorySlug,
  });
  Future<List<CategoryModel>> getCategories();
  Future<ArticleModel> getArticle(String slug);
  Future<(List<ArticleModel>, PaginationMeta)> searchArticles(
    String query, {
    int page,
  });
  Future<List<ArticleModel>> getRelatedArticles(String slug);
  Future<(List<WebStoryModel>, PaginationMeta)> getWebStories({int page});
  Future<WebStoryModel> getStoryDetail(String slug);
  Future<(List<ShortVideoModel>, PaginationMeta)> getShorts({int page});
  Future<SiteSettingsModel> getSettings();
  Future<({String question, String token})> getCaptcha();
  Future<void> postComment(CommentRequest request);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final DioClient _client;

  NewsRemoteDataSourceImpl(this._client);

  Future<Map<String, dynamic>> _fetch(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _client.get(path, queryParameters: params);
      final body = response.data;
      if (body is Map) {
        return Map<String, dynamic>.from(body as Map);
      }
      throw const ServerException('Invalid response format');
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error as ApiException;
      throw ServerException(
        e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  PaginationMeta _parseMeta(Map<String, dynamic> body) {
    final meta = body['meta'];
    if (meta is Map) {
      return PaginationMeta(
        page: (meta['page'] as num?)?.toInt() ?? 1,
        perPage: (meta['per_page'] as num?)?.toInt() ?? 15,
        total: (meta['total'] as num?)?.toInt() ?? 0,
      );
    }
    return const PaginationMeta(page: 1, perPage: 15, total: 0);
  }

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList();
    }
    return [];
  }

  @override
  Future<(List<ArticleModel>, PaginationMeta)> getLatestNews({
    int page = 1,
    int perPage = 15,
    String? categorySlug,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (categorySlug != null && categorySlug.isNotEmpty) {
      params['category'] = categorySlug;
    }
    final body = await _fetch(ApiConstants.latest, params: params);
    final articles = _parseList(body['data'], ArticleModel.fromJson);
    final meta = _parseMeta(body);
    return (articles, meta);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final body = await _fetch(ApiConstants.categories);
    return _parseList(body['data'], CategoryModel.fromJson);
  }

  @override
  Future<ArticleModel> getArticle(String slug) async {
    final body = await _fetch('${ApiConstants.article}/$slug');
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      return ArticleModel.fromJson(data);
    }
    throw const ServerException('Invalid article response');
  }

  @override
  Future<(List<ArticleModel>, PaginationMeta)> searchArticles(
    String query, {
    int page = 1,
  }) async {
    final body = await _fetch(
      ApiConstants.search,
      params: {'q': query, 'page': page},
    );
    final articles = _parseList(body['data'], ArticleModel.fromJson);
    final meta = _parseMeta(body);
    return (articles, meta);
  }

  @override
  Future<List<ArticleModel>> getRelatedArticles(String slug) async {
    final body = await _fetch('${ApiConstants.related}/$slug');
    return _parseList(body['data'], ArticleModel.fromJson);
  }

  @override
  Future<(List<WebStoryModel>, PaginationMeta)> getWebStories({
    int page = 1,
  }) async {
    final body = await _fetch(ApiConstants.webStories, params: {'page': page});
    final stories = _parseList(body['data'], WebStoryModel.fromJson);
    final meta = _parseMeta(body);
    return (stories, meta);
  }

  @override
  Future<WebStoryModel> getStoryDetail(String slug) async {
    final body = await _fetch(ApiConstants.storyDetail, params: {'slug': slug});
    return WebStoryModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<(List<ShortVideoModel>, PaginationMeta)> getShorts({
    int page = 1,
  }) async {
    final body = await _fetch(ApiConstants.shorts, params: {'page': page});
    final shorts = _parseList(body['data'], ShortVideoModel.fromJson);
    final meta = _parseMeta(body);
    return (shorts, meta);
  }

  @override
  Future<SiteSettingsModel> getSettings() async {
    final body = await _fetch(ApiConstants.settings);
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      return SiteSettingsModel.fromJson(data);
    }
    return const SiteSettingsModel(
      siteName: 'Namasteram News',
      tagline: '',
      primaryColor: '#E53935',
      contactEmail: '',
    );
  }

  @override
  Future<({String question, String token})> getCaptcha() async {
    final body = await _fetch(ApiConstants.captcha);
    final data = body['data'];
    if (data is Map) {
      return (
        question: data['question']?.toString() ?? '',
        token: data['token']?.toString() ?? '',
      );
    }
    return (question: '', token: '');
  }

  @override
  Future<void> postComment(CommentRequest request) async {
    try {
      final response = await _client.post(
        ApiConstants.comments,
        data: {
          'article_id': request.articleId,
          'name': request.name,
          'email': request.email,
          'content': request.content,
          'captcha_answer': request.captcha,
          'captcha_token': request.captchaToken,
        },
      );
      final body = response.data;
      if (body is Map && body['success'] == true) {
        return;
      }
      final msg = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : 'Failed to post comment';
      throw ServerException(msg);
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error as ApiException;
      throw ServerException(
        e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
