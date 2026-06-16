import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_stories.dart';
import 'web_stories_event.dart';
import 'web_stories_state.dart';

class WebStoriesBloc extends Bloc<WebStoriesEvent, WebStoriesState> {
  final GetWebStories _getWebStories;

  WebStoriesBloc({required GetWebStories getWebStories})
      : _getWebStories = getWebStories,
        super(const WebStoriesInitial()) {
    on<LoadWebStoriesEvent>(_onLoad);
    on<LoadMoreWebStoriesEvent>(_onLoadMore);
  }

  Future<void> _onLoad(
    LoadWebStoriesEvent event,
    Emitter<WebStoriesState> emit,
  ) async {
    emit(const WebStoriesLoading());
    try {
      final (stories, meta) = await _getWebStories(page: 1);
      emit(WebStoriesLoaded(stories: stories, hasMore: meta.hasMore, page: 1));
    } catch (e) {
      emit(WebStoriesError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreWebStoriesEvent event,
    Emitter<WebStoriesState> emit,
  ) async {
    final current = state;
    if (current is! WebStoriesLoaded || !current.hasMore) return;
    try {
      final nextPage = current.page + 1;
      final (stories, meta) = await _getWebStories(page: nextPage);
      emit(current.copyWith(
        stories: [...current.stories, ...stories],
        hasMore: meta.hasMore,
        page: nextPage,
      ));
    } catch (_) {}
  }
}
