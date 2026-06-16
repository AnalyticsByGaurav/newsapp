import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../blocs/article/article_bloc.dart';
import '../blocs/bookmarks/bookmarks_bloc.dart';
import '../blocs/bookmarks/bookmarks_event.dart';
import '../blocs/categories/categories_bloc.dart';
import '../blocs/categories/categories_event.dart';
import '../blocs/comment/comment_bloc.dart';
import '../blocs/news/news_bloc.dart';
import '../blocs/news/news_event.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/shorts/shorts_bloc.dart';
import '../blocs/shorts/shorts_event.dart';
import '../blocs/web_stories/web_stories_bloc.dart';
import '../blocs/web_stories/web_stories_event.dart';
import '../pages/home/home_page.dart';
import '../pages/category/category_page.dart';
import '../pages/article/article_page.dart';
import '../pages/search/search_page.dart';
import '../pages/stories/stories_page.dart';
import '../pages/stories/story_viewer_page.dart';
import '../pages/shorts/shorts_page.dart';
import '../pages/bookmarks/bookmarks_page.dart';
import '../pages/notifications/notifications_page.dart';
import '../pages/settings/settings_page.dart';
import 'main_scaffold.dart';

final sl = GetIt.instance;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/categories',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) =>
                    sl<CategoriesBloc>()..add(const LoadCategoriesEvent()),
                child: const CategoryPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/shorts',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) =>
                    sl<ShortsBloc>()..add(const LoadShortsEvent()),
                child: const ShortsPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/bookmarks',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) =>
                    sl<BookmarksBloc>()..add(const LoadBookmarksEvent()),
                child: const BookmarksPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/category/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          final name = state.uri.queryParameters['name'] ?? slug;
          return BlocProvider(
            create: (_) => sl<HomeBloc>()
              ..add(HomeLoadEvent(categorySlug: slug)),
            child: CategoryArticlesPage(categorySlug: slug, categoryName: name),
          );
        },
      ),
      GoRoute(
        path: '/article/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    sl<ArticleBloc>()..add(LoadArticleEvent(slug: slug)),
              ),
              BlocProvider(create: (_) => sl<CommentBloc>()),
            ],
            child: ArticlePage(slug: slug),
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SearchBloc>(),
          child: const SearchPage(),
        ),
      ),
      GoRoute(
        path: '/web-stories',
        builder: (context, state) => BlocProvider(
          create: (_) =>
              sl<WebStoriesBloc>()..add(const LoadWebStoriesEvent()),
          child: const WebStoriesPage(),
        ),
      ),
      GoRoute(
        path: '/story/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return WebStoryViewPage(slug: slug);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );
}
