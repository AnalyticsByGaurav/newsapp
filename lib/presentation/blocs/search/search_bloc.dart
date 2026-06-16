import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_news.dart';
import 'search_event.dart';
import 'search_state.dart';

// Internal debounce event
class _SearchExecuteEvent extends SearchEvent {
  final String query;
  const _SearchExecuteEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchArticles _searchArticles;
  Timer? _debounce;

  SearchBloc({required SearchArticles searchArticles})
      : _searchArticles = searchArticles,
        super(const SearchInitial()) {
    on<SearchQueryChangedEvent>(_onQueryChanged);
    on<_SearchExecuteEvent>(_onExecuteSearch);
    on<SearchLoadMoreEvent>(_onLoadMore);
    on<SearchClearEvent>(_onClear);
  }

  Future<void> _onQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    _debounce?.cancel();
    if (event.query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }
    emit(const SearchLoading());
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!isClosed) add(_SearchExecuteEvent(event.query.trim()));
    });
  }

  Future<void> _onExecuteSearch(
    _SearchExecuteEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final (articles, meta) = await _searchArticles(
        SearchArticlesParams(query: event.query, page: 1),
      );
      if (articles.isEmpty) {
        emit(SearchEmpty(query: event.query));
      } else {
        emit(SearchLoaded(
          articles: articles,
          query: event.query,
          hasMore: meta.hasMore,
          page: 1,
        ));
      }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    SearchLoadMoreEvent event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;
    if (current is! SearchLoaded || !current.hasMore) return;
    try {
      final nextPage = current.page + 1;
      final (articles, meta) = await _searchArticles(
        SearchArticlesParams(query: current.query, page: nextPage),
      );
      emit(SearchLoaded(
        articles: [...current.articles, ...articles],
        query: current.query,
        hasMore: meta.hasMore,
        page: nextPage,
      ));
    } catch (_) {}
  }

  Future<void> _onClear(SearchClearEvent event, Emitter<SearchState> emit) async {
    _debounce?.cancel();
    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
