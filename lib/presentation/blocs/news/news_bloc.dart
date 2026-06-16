import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../domain/usecases/get_latest_news.dart';
import 'news_event.dart';
import 'news_state.dart';

class HomeBloc extends Bloc<NewsEvent, NewsState> {
  final GetLatestNews _getLatestNews;

  HomeBloc({required GetLatestNews getLatestNews})
      : _getLatestNews = getLatestNews,
        super(const HomeInitial()) {
    on<HomeLoadEvent>(_onLoad);
    on<HomeLoadMoreEvent>(_onLoadMore);
    on<HomeRefreshEvent>(_onRefresh);
  }

  Future<void> _onLoad(HomeLoadEvent event, Emitter<NewsState> emit) async {
    emit(const HomeLoading());
    try {
      final (articles, meta) = await _getLatestNews(GetLatestNewsParams(
        page: 1,
        perPage: ApiConstants.defaultPerPage,
        categorySlug: event.categorySlug,
      ));
      emit(HomeLoaded(
        articles: articles,
        hasMore: meta.hasMore,
        page: 1,
        categorySlug: event.categorySlug,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    HomeLoadMoreEvent event,
    Emitter<NewsState> emit,
  ) async {
    final current = state;
    if (current is! HomeLoaded || !current.hasMore) return;

    emit(HomeLoadingMore(
      articles: current.articles,
      hasMore: current.hasMore,
      page: current.page,
      categorySlug: current.categorySlug,
    ));

    try {
      final nextPage = current.page + 1;
      final (newArticles, meta) = await _getLatestNews(GetLatestNewsParams(
        page: nextPage,
        perPage: ApiConstants.defaultPerPage,
        categorySlug: current.categorySlug,
      ));
      emit(current.copyWith(
        articles: [...current.articles, ...newArticles],
        hasMore: meta.hasMore,
        page: nextPage,
      ));
    } catch (_) {
      emit(current);
    }
  }

  Future<void> _onRefresh(
    HomeRefreshEvent event,
    Emitter<NewsState> emit,
  ) async {
    try {
      final (articles, meta) = await _getLatestNews(GetLatestNewsParams(
        page: 1,
        perPage: ApiConstants.defaultPerPage,
        categorySlug: event.categorySlug,
      ));
      emit(HomeLoaded(
        articles: articles,
        hasMore: meta.hasMore,
        page: 1,
        categorySlug: event.categorySlug,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
