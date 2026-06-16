import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/article.dart';
import '../../blocs/categories/categories_bloc.dart';
import '../../blocs/categories/categories_event.dart';
import '../../blocs/categories/categories_state.dart';
import '../../blocs/news/news_bloc.dart';
import '../../blocs/news/news_event.dart';
import '../../blocs/news/news_state.dart';
import '../../widgets/article_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<HomeBloc>().state;
      if (state is HomeLoaded && state.hasMore && state is! HomeLoadingMore) {
        context.read<HomeBloc>().add(const HomeLoadMoreEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final catState = context.read<CategoriesBloc>().state;
          final slug = catState is CategoriesLoaded ? catState.selectedSlug : null;
          context.read<HomeBloc>().add(HomeRefreshEvent(categorySlug: slug));
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: const Text('नमस्तेराम न्यूज़'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'खोजें',
                  onPressed: () => context.push('/search'),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  tooltip: 'सूचनाएं',
                  onPressed: () => context.push('/notifications'),
                ),
              ],
            ),
            // Breaking/featured news banner
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, NewsState>(
                builder: (context, state) {
                  if (state is HomeLoaded && state.articles.isNotEmpty) {
                    return _FeaturedBanner(articles: state.articles.take(5).toList());
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            // Category filter chips
            SliverToBoxAdapter(
              child: BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, state) {
                  if (state is CategoriesLoaded && state.categories.isNotEmpty) {
                    return SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        children: [
                          CategoryChip(
                            label: 'सभी',
                            color: '#E53935',
                            isSelected: state.selectedSlug == null,
                            onTap: () {
                              context.read<CategoriesBloc>().add(
                                LoadCategoriesEvent(),
                              );
                              context.read<HomeBloc>().add(const HomeLoadEvent());
                            },
                          ),
                          ...state.categories.map((cat) => CategoryChip(
                            label: cat.name,
                            color: '#E53935',
                            isSelected: state.selectedSlug == cat.slug,
                            onTap: () {
                              context.read<HomeBloc>().add(
                                HomeLoadEvent(categorySlug: cat.slug),
                              );
                            },
                          )),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SliverToBoxAdapter(child: Divider(height: 1)),
            // Article list
            BlocBuilder<HomeBloc, NewsState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const SliverToBoxAdapter(child: ArticleListShimmer());
                }
                if (state is HomeError) {
                  return SliverFillRemaining(
                    child: AppErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<HomeBloc>().add(const HomeLoadEvent());
                      },
                    ),
                  );
                }
                if (state is HomeLoaded || state is HomeLoadingMore) {
                  final articles = state is HomeLoaded
                      ? state.articles
                      : (state as HomeLoadingMore).articles;
                  final hasMore = state is HomeLoaded
                      ? state.hasMore
                      : (state as HomeLoadingMore).hasMore;

                  if (articles.isEmpty) {
                    return const SliverFillRemaining(
                      child: AppEmptyWidget(
                        message: 'कोई समाचार नहीं मिला।',
                        icon: Icons.article_outlined,
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == articles.length) {
                          if (state is HomeLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (hasMore) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'सभी समाचार लोड हो गए',
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ),
                          );
                        }
                        final article = articles[index];
                        return index == 0
                            ? ArticleCardLarge(article: article)
                            : ArticleCard(article: article);
                      },
                      childCount: articles.length + 1,
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedBanner extends StatefulWidget {
  final List<Article> articles;

  const _FeaturedBanner({required this.articles});

  @override
  State<_FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<_FeaturedBanner> {
  late final PageController _pageController;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _autoAdvance();
  }

  void _autoAdvance() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      final next = (_current + 1) % widget.articles.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _autoAdvance();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.articles.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) {
              final a = widget.articles[i];
              return GestureDetector(
                onTap: () => context.push('/article/${a.slug}'),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (a.imageUrl != null)
                      Image.network(
                        a.webpUrl ?? a.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                      )
                    else
                      Container(color: Colors.grey[300]),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        a.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansDevanagari',
                          shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 8,
            right: 16,
            child: Row(
              children: List.generate(widget.articles.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(left: 4),
                width: _current == i ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(3),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
