import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_bookmarks.dart';
import '../../../domain/usecases/toggle_bookmark.dart';
import '../../../domain/repositories/news_repository.dart';
import 'bookmarks_event.dart';
import 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final GetBookmarks _getBookmarks;
  final ToggleBookmark _toggleBookmark;
  final NewsRepository _repository;

  BookmarksBloc({
    required GetBookmarks getBookmarks,
    required ToggleBookmark toggleBookmark,
    required NewsRepository repository,
  })  : _getBookmarks = getBookmarks,
        _toggleBookmark = toggleBookmark,
        _repository = repository,
        super(const BookmarksInitial()) {
    on<LoadBookmarksEvent>(_onLoad);
    on<ToggleBookmarkEvent>(_onToggle);
    on<RemoveBookmarkEvent>(_onRemove);
  }

  void _onLoad(LoadBookmarksEvent event, Emitter<BookmarksState> emit) {
    final bookmarks = _getBookmarks();
    emit(BookmarksLoaded(bookmarks: bookmarks));
  }

  Future<void> _onToggle(
    ToggleBookmarkEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    await _toggleBookmark(event.article);
    final bookmarks = _getBookmarks();
    emit(BookmarksLoaded(bookmarks: bookmarks));
  }

  Future<void> _onRemove(
    RemoveBookmarkEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    await _repository.removeBookmark(event.slug);
    final bookmarks = _getBookmarks();
    emit(BookmarksLoaded(bookmarks: bookmarks));
  }
}
