import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../network/dio_client.dart';
import '../utils/cache_manager.dart';
import '../../data/datasources/local/news_local_datasource.dart';
import '../../data/datasources/remote/news_remote_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_article.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/get_captcha.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../../domain/usecases/get_related_articles.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/get_shorts.dart';
import '../../domain/usecases/get_stories.dart';
import '../../domain/usecases/post_comment.dart';
import '../../domain/usecases/search_news.dart';
import '../../domain/usecases/toggle_bookmark.dart';
import '../../presentation/blocs/news/news_bloc.dart';
import '../../presentation/blocs/categories/categories_bloc.dart';
import '../../presentation/blocs/article/article_bloc.dart';
import '../../presentation/blocs/search/search_bloc.dart';
import '../../presentation/blocs/web_stories/web_stories_bloc.dart';
import '../../presentation/blocs/shorts/shorts_bloc.dart';
import '../../presentation/blocs/bookmarks/bookmarks_bloc.dart';
import '../../presentation/blocs/settings/settings_bloc.dart';
import '../../presentation/blocs/comment/comment_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // External dependencies
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Hive boxes
  sl.registerLazySingleton<Box>(
    () => Hive.box(AppConstants.hiveBoxArticles),
    instanceName: 'articles',
  );
  sl.registerLazySingleton<Box>(
    () => Hive.box(AppConstants.hiveBoxBookmarks),
    instanceName: 'bookmarks',
  );
  sl.registerLazySingleton<Box>(
    () => Hive.box(AppConstants.hiveBoxSettings),
    instanceName: 'settings',
  );
  sl.registerLazySingleton<Box>(
    () => Hive.box(AppConstants.hiveBoxCategories),
    instanceName: 'categories',
  );

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  sl.registerLazySingleton<CacheManager>(
    () => CacheManager(sl<Box>(instanceName: 'categories')),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(
      articlesBox: sl<Box>(instanceName: 'articles'),
      bookmarksBox: sl<Box>(instanceName: 'bookmarks'),
      settingsBox: sl<Box>(instanceName: 'settings'),
      cacheManager: sl<CacheManager>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remote: sl<NewsRemoteDataSource>(),
      local: sl<NewsLocalDataSource>(),
      connectivity: sl<Connectivity>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetLatestNews(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetCategories(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetArticle(sl<NewsRepository>()));
  sl.registerLazySingleton(() => SearchArticles(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetRelatedArticles(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetWebStories(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetShorts(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetSettings(sl<NewsRepository>()));
  sl.registerLazySingleton(() => PostComment(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetCaptcha(sl<NewsRepository>()));
  sl.registerLazySingleton(() => ToggleBookmark(sl<NewsRepository>()));
  sl.registerLazySingleton(() => GetBookmarks(sl<NewsRepository>()));

  // BLoCs - registered as factories so each widget tree creates a fresh instance
  sl.registerFactory(
    () => HomeBloc(getLatestNews: sl<GetLatestNews>()),
  );
  sl.registerFactory(
    () => CategoriesBloc(getCategories: sl<GetCategories>()),
  );
  sl.registerFactory(
    () => ArticleBloc(
      getArticle: sl<GetArticle>(),
      toggleBookmark: sl<ToggleBookmark>(),
      repository: sl<NewsRepository>(),
    ),
  );
  sl.registerFactory(
    () => SearchBloc(searchArticles: sl<SearchArticles>()),
  );
  sl.registerFactory(
    () => WebStoriesBloc(getWebStories: sl<GetWebStories>()),
  );
  sl.registerFactory(
    () => ShortsBloc(getShorts: sl<GetShorts>()),
  );
  sl.registerFactory(
    () => BookmarksBloc(
      getBookmarks: sl<GetBookmarks>(),
      toggleBookmark: sl<ToggleBookmark>(),
      repository: sl<NewsRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => SettingsBloc(
      getSettings: sl<GetSettings>(),
      settingsBox: sl<Box>(instanceName: 'settings'),
    ),
  );
  sl.registerFactory(
    () => CommentBloc(
      getCaptcha: sl<GetCaptcha>(),
      postComment: sl<PostComment>(),
    ),
  );
}
