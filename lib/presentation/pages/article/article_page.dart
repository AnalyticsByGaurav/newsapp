import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/html_parser.dart';
import '../../blocs/article/article_bloc.dart';
import '../../blocs/article/article_event.dart';
import '../../blocs/article/article_state.dart';
import '../../blocs/comment/comment_bloc.dart';
import '../../blocs/comment/comment_event.dart';
import '../../blocs/comment/comment_state.dart';
import '../../widgets/article_card.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../../domain/entities/article.dart';

class ArticlePage extends StatelessWidget {
  final String slug;

  const ArticlePage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) {
        if (state is ArticleLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ArticleError) {
          return Scaffold(
            appBar: AppBar(),
            body: AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<ArticleBloc>().add(LoadArticleEvent(slug: slug)),
            ),
          );
        }
        if (state is ArticleLoaded) {
          return _ArticleDetailView(state: state);
        }
        return Scaffold(appBar: AppBar());
      },
    );
  }
}

class _ArticleDetailView extends StatelessWidget {
  final ArticleLoaded state;

  const _ArticleDetailView({required this.state});

  @override
  Widget build(BuildContext context) {
    final article = state.article;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.categoryHi?.isNotEmpty == true
              ? article.categoryHi!
              : article.category.isNotEmpty ? article.category : 'समाचार',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(
              state.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: state.isBookmarked ? theme.colorScheme.primary : null,
            ),
            tooltip: state.isBookmarked ? 'बुकमार्क हटाएं' : 'बुकमार्क करें',
            onPressed: () => context.read<ArticleBloc>().add(
              const ToggleArticleBookmarkEvent(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'शेयर करें',
            onPressed: () {
              final url = '${ApiConstants.baseUrl.replaceAll('/api/v1', '')}/article/${article.slug}';
              Share.share('${article.displayTitle}\n\n$url');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            if (article.imageUrl != null)
              SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: article.webpUrl ?? article.imageUrl!,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  memCacheHeight: 450,
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: (_, __) => const ShimmerBox(
                    width: double.infinity,
                    height: 220,
                    borderRadius: 0,
                  ),
                  errorWidget: (_, __, ___) => const SizedBox(height: 220),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  if (article.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.categoryHi?.isNotEmpty == true
                            ? article.categoryHi!
                            : article.category,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSansDevanagari',
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    article.displayTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Meta row
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        article.author,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        TimeAgoHelper.format(article.publishedAt),
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${article.views}',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tags
                  if (article.tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: article.tags.map((tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                  const Divider(height: 24),
                  // Excerpt
                  if (article.excerpt.isNotEmpty)
                    Text(
                      article.displayExcerpt,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  if (article.excerpt.isNotEmpty) const SizedBox(height: 16),
                  // Content
                  HtmlParser.parse(
                    article.content,
                    baseStyle: theme.textTheme.bodyLarge,
                  ),
                  const Divider(height: 32),
                  // Related articles
                  if (article.related.isNotEmpty) ...[
                    Text(
                      'संबंधित समाचार',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: article.related.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return _RelatedCard(article: article.related[index]);
                        },
                      ),
                    ),
                    const Divider(height: 32),
                  ],
                  // Comment section
                  _CommentSection(articleId: article.id),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedCard extends StatelessWidget {
  final Article article;

  const _RelatedCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/article/${article.slug}'),
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 100,
                width: 160,
                child: article.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: article.webpUrl ?? article.imageUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth: 320,
                        memCacheHeight: 200,
                        fadeInDuration: const Duration(milliseconds: 150),
                        placeholder: (_, __) => Container(color: Colors.grey[200]),
                        errorWidget: (_, __, ___) => Container(color: Colors.grey[200]),
                      )
                    : Container(color: Colors.grey[200]),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              article.displayTitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'NotoSansDevanagari'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentSection extends StatefulWidget {
  final int articleId;

  const _CommentSection({required this.articleId});

  @override
  State<_CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<_CommentSection> {
  bool _expanded = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contentController = TextEditingController();
  final _captchaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contentController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'टिप्पणी करें',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (!_expanded)
          OutlinedButton.icon(
            onPressed: () {
              setState(() => _expanded = true);
              context.read<CommentBloc>().add(const LoadCaptchaEvent());
            },
            icon: const Icon(Icons.add_comment_outlined),
            label: const Text('टिप्पणी जोड़ें'),
          )
        else
          BlocConsumer<CommentBloc, CommentState>(
            listener: (context, state) {
              if (state is CommentSubmitted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                setState(() => _expanded = false);
                _nameController.clear();
                _emailController.clear();
                _contentController.clear();
                _captchaController.clear();
              } else if (state is CommentError && state is! CaptchaLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'नाम *'),
                      validator: (v) => v == null || v.isEmpty ? 'नाम आवश्यक है' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'ईमेल *'),
                      validator: (v) => v == null || !v.contains('@') ? 'वैध ईमेल दर्ज करें' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'टिप्पणी *'),
                      validator: (v) => v == null || v.length < 10 ? 'कम से कम 10 अक्षर लिखें' : null,
                    ),
                    const SizedBox(height: 12),
                    // CAPTCHA
                    if (state is CaptchaLoaded) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'सुरक्षा प्रश्न: ${state.question}',
                                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context.read<CommentBloc>().add(const LoadCaptchaEvent()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _captchaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'उत्तर *'),
                        validator: (v) => v == null || v.isEmpty ? 'उत्तर आवश्यक है' : null,
                      ),
                    ] else if (state is CaptchaLoading) ...[
                      const Center(child: CircularProgressIndicator()),
                    ] else if (state is CommentError) ...[
                      Text(state.message, style: TextStyle(color: theme.colorScheme.error)),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => setState(() => _expanded = false),
                          child: const Text('रद्द करें'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: state is CommentSubmitting
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() == true && state is CaptchaLoaded) {
                                    context.read<CommentBloc>().add(SubmitCommentEvent(
                                      articleId: widget.articleId,
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      content: _contentController.text,
                                      captcha: _captchaController.text,
                                      captchaToken: state.token,
                                    ));
                                  }
                                },
                          child: state is CommentSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('पोस्ट करें'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
