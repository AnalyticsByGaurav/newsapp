# Modified/Created Files — Namasteram News Portal

This document tracks all files modified or created during the June 2025 development audit and Flutter app integration.

---

## PHP Backend Changes

| File | Status | Description |
|------|--------|-------------|
| `css/style.css` | Modified | Font changes to Noto Sans Devanagari, image aspect-ratio fix, comment form layout |
| `includes/header.php` | Modified | Added Noto Sans Devanagari Google Font import |
| `article.php` | Modified | Featured image fix, WebP srcset with `<picture>` element, comment form, CAPTCHA |
| `api/comments.php` | Modified | Complete rewrite with spam protection, honeypot, disposable email detection |
| `js/app.js` | Modified | Comment form handler updated for new CAPTCHA flow |
| `img.php` | **NEW** | On-demand image resize and conversion to WebP format |
| `migrate_api.sql` | **NEW** | Database migration for API tables (api_keys, api_requests) |
| `api/v1/index.php` | **NEW** | REST API router — handles all v1 endpoints |
| `api/admin.php` | Modified | Added API key management functions (generate, revoke, list) |
| `admin/index.html` | Modified | Added "API Management" module to admin panel |
| `.htaccess` | Modified | Added RewriteRules for `/api/v1/*` routing |
| `404.php` | Modified | Font family updated to NotoSansDevanagari |
| `web-story.php` | Modified | Font family updated to NotoSansDevanagari |
| `video.php` | Modified | Font family updated to NotoSansDevanagari |
| `pages/login.php` | Modified | Font family updated to NotoSansDevanagari |
| `pages/register.php` | Modified | Font family updated to NotoSansDevanagari |

---

## Flutter App (NEW — flutter_app/)

### Configuration
| File | Description |
|------|-------------|
| `pubspec.yaml` | Flutter project config, dependencies, font declarations |
| `android/app/build.gradle` | Android build config (compileSdk 34, minSdk 21) |

### Core Layer
| File | Description |
|------|-------------|
| `lib/core/constants/api_constants.dart` | API base URL, key, endpoint paths |
| `lib/core/constants/app_constants.dart` | App name, Hive box names, pref keys |
| `lib/core/theme/app_theme.dart` | Material 3 light/dark themes, NotoSansDevanagari font |
| `lib/core/network/dio_client.dart` | Singleton Dio HTTP client |
| `lib/core/network/api_interceptor.dart` | X-API-Key header, retry logic, error mapping |
| `lib/core/errors/exceptions.dart` | ApiException, NetworkException, ServerException hierarchy |
| `lib/core/errors/failures.dart` | Failure types for error propagation |
| `lib/core/di/injection_container.dart` | GetIt service locator setup |
| `lib/core/utils/html_parser.dart` | HTML to Flutter Widget converter |
| `lib/core/utils/date_utils.dart` | Hindi time-ago formatting |
| `lib/core/utils/cache_manager.dart` | TTL-based Hive cache manager |

### Domain Layer
| File | Description |
|------|-------------|
| `lib/domain/entities/article.dart` | Article entity |
| `lib/domain/entities/category.dart` | Category entity |
| `lib/domain/entities/story.dart` | WebStory entity |
| `lib/domain/entities/short.dart` | ShortVideo entity |
| `lib/domain/entities/comment.dart` | CommentRequest entity |
| `lib/domain/entities/site_settings.dart` | SiteSettings entity |
| `lib/domain/entities/pagination_meta.dart` | PaginationMeta with hasMore helper |
| `lib/domain/repositories/news_repository.dart` | Abstract repository interface |
| `lib/domain/usecases/get_latest_news.dart` | Use case |
| `lib/domain/usecases/get_categories.dart` | Use case |
| `lib/domain/usecases/get_article.dart` | Use case |
| `lib/domain/usecases/search_news.dart` | Use case (SearchArticles) |
| `lib/domain/usecases/get_related_articles.dart` | Use case |
| `lib/domain/usecases/get_stories.dart` | Use case (GetWebStories) |
| `lib/domain/usecases/get_shorts.dart` | Use case |
| `lib/domain/usecases/get_settings.dart` | Use case |
| `lib/domain/usecases/post_comment.dart` | Use case |
| `lib/domain/usecases/get_captcha.dart` | Use case |
| `lib/domain/usecases/toggle_bookmark.dart` | Use case |
| `lib/domain/usecases/get_bookmarks.dart` | Use case |

### Data Layer
| File | Description |
|------|-------------|
| `lib/data/models/article_model.dart` | Article fromJson/toJson |
| `lib/data/models/category_model.dart` | Category fromJson/toJson |
| `lib/data/models/story_model.dart` | WebStory fromJson/toJson |
| `lib/data/models/short_model.dart` | ShortVideo fromJson/toJson |
| `lib/data/models/site_settings_model.dart` | SiteSettings fromJson/toJson |
| `lib/data/datasources/remote/news_remote_datasource.dart` | Dio-based remote data source |
| `lib/data/datasources/local/news_local_datasource.dart` | Hive-based local cache + bookmarks |
| `lib/data/repositories/news_repository_impl.dart` | Repository with offline fallback |

### Presentation Layer — BLoCs
| File | Description |
|------|-------------|
| `lib/presentation/blocs/news/news_bloc.dart` | HomeBloc (load, refresh, load-more) |
| `lib/presentation/blocs/news/news_event.dart` | HomeLoadEvent, HomeRefreshEvent, HomeLoadMoreEvent |
| `lib/presentation/blocs/news/news_state.dart` | HomeInitial, HomeLoading, HomeLoaded, HomeError |
| `lib/presentation/blocs/categories/categories_bloc.dart` | Categories BLoC |
| `lib/presentation/blocs/article/article_bloc.dart` | Article detail + bookmark toggle |
| `lib/presentation/blocs/search/search_bloc.dart` | Debounced search with pagination |
| `lib/presentation/blocs/web_stories/web_stories_bloc.dart` | Web stories BLoC |
| `lib/presentation/blocs/shorts/shorts_bloc.dart` | Shorts BLoC |
| `lib/presentation/blocs/bookmarks/bookmarks_bloc.dart` | Bookmarks BLoC |
| `lib/presentation/blocs/settings/settings_bloc.dart` | Settings + dark mode + font size |
| `lib/presentation/blocs/comment/comment_bloc.dart` | CAPTCHA load + comment submit |

### Presentation Layer — Pages
| File | Description |
|------|-------------|
| `lib/presentation/pages/home/home_page.dart` | Home with breaking news banner, category filter, infinite scroll |
| `lib/presentation/pages/category/category_page.dart` | Category grid + articles list |
| `lib/presentation/pages/article/article_page.dart` | Article detail, HTML content, comments, related |
| `lib/presentation/pages/search/search_page.dart` | Debounced search page |
| `lib/presentation/pages/stories/stories_page.dart` | Web stories grid |
| `lib/presentation/pages/stories/story_viewer_page.dart` | Full-screen story viewer with auto-advance |
| `lib/presentation/pages/shorts/shorts_page.dart` | TikTok-style vertical video scroll |
| `lib/presentation/pages/bookmarks/bookmarks_page.dart` | Bookmarks with swipe-to-delete |
| `lib/presentation/pages/notifications/notifications_page.dart` | Push notification history |
| `lib/presentation/pages/settings/settings_page.dart` | Dark mode, font size, cache clear |

### Presentation Layer — Widgets
| File | Description |
|------|-------------|
| `lib/presentation/widgets/article_card.dart` | ArticleCard (list) + ArticleCardLarge (featured) |
| `lib/presentation/widgets/category_chip.dart` | Category filter chip |
| `lib/presentation/widgets/loading_widget.dart` | Custom shimmer loading effect |
| `lib/presentation/widgets/error_widget.dart` | Error state with retry button |
| `lib/presentation/widgets/empty_widget.dart` | Empty state with icon |

### Navigation
| File | Description |
|------|-------------|
| `lib/presentation/router/app_router.dart` | GoRouter configuration |
| `lib/presentation/router/main_scaffold.dart` | Bottom navigation shell |
| `lib/main.dart` | App entry point with Hive init, DI setup, Firebase |

### Documentation
| File | Description |
|------|-------------|
| `docs/API_DOCUMENTATION.md` | Full API reference with examples |
| `docs/DEPLOYMENT_GUIDE.md` | Setup, build, and release instructions |
| `docs/SECURITY_REPORT.md` | Security measures and best practices |
| `docs/MODIFIED_FILES.md` | This file — change log |
| `README.md` | Quick start guide |
