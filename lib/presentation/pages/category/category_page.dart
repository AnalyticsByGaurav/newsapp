import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/categories/categories_bloc.dart';
import '../../blocs/categories/categories_event.dart';
import '../../blocs/categories/categories_state.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/entities/category.dart';
import '../../blocs/news/news_bloc.dart';
import '../../blocs/news/news_event.dart';
import '../../blocs/news/news_state.dart';
import '../../widgets/article_card.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('श्रेणियां')),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 80),
            );
          }
          if (state is CategoriesError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<CategoriesBloc>().add(const LoadCategoriesEvent()),
            );
          }
          if (state is CategoriesLoaded) {
            if (state.categories.isEmpty) {
              return const AppEmptyWidget(
                message: 'कोई श्रेणी नहीं मिली।',
                icon: Icons.category_outlined,
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final cat = state.categories[index];
                return _CategoryCard(category: cat);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = [
      Colors.red, Colors.blue, Colors.green, Colors.orange,
      Colors.purple, Colors.teal, Colors.indigo, Colors.amber,
    ];
    final color = colors[category.id % colors.length];

    return InkWell(
      onTap: () => context.push('/category/${category.slug}?name=${Uri.encodeComponent(category.name)}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.8), color],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansDevanagari',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${category.count} समाचार',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'NotoSansDevanagari',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryArticlesPage extends StatelessWidget {
  final String categorySlug;
  final String categoryName;

  const CategoryArticlesPage({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: BlocBuilder<HomeBloc, NewsState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const ArticleListShimmer();
          }
          if (state is HomeError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<HomeBloc>().add(
                HomeLoadEvent(categorySlug: categorySlug),
              ),
            );
          }
          if (state is HomeLoaded || state is HomeLoadingMore) {
            final articles = state is HomeLoaded
                ? state.articles
                : (state as HomeLoadingMore).articles;
            if (articles.isEmpty) {
              return const AppEmptyWidget(message: 'इस श्रेणी में कोई समाचार नहीं।');
            }
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) => ArticleCard(article: articles[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
