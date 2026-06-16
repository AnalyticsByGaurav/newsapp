import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_article.dart';
import '../../../domain/usecases/toggle_bookmark.dart';
import '../../../domain/repositories/news_repository.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticle _getArticle;
  final ToggleBookmark _toggleBookmark;
  final NewsRepository _repository;

  ArticleBloc({
    required GetArticle getArticle,
    required ToggleBookmark toggleBookmark,
    required NewsRepository repository,
  })  : _getArticle = getArticle,
        _toggleBookmark = toggleBookmark,
        _repository = repository,
        super(const ArticleInitial()) {
    on<LoadArticleEvent>(_onLoad);
    on<ToggleArticleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onLoad(
    LoadArticleEvent event,
    Emitter<ArticleState> emit,
  ) async {
    emit(const ArticleLoading());
    try {
      final article = await _getArticle(event.slug);
      final isBookmarked = _repository.isBookmarked(article.slug);
      emit(ArticleLoaded(article: article, isBookmarked: isBookmarked));
    } catch (e) {
      emit(ArticleError(message: e.toString()));
    }
  }

  Future<void> _onToggleBookmark(
    ToggleArticleBookmarkEvent event,
    Emitter<ArticleState> emit,
  ) async {
    final current = state;
    if (current is! ArticleLoaded) return;
    try {
      final newState = await _toggleBookmark(current.article);
      emit(current.copyWith(isBookmarked: newState));
    } catch (_) {}
  }
}
