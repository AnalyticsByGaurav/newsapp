import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_shorts.dart';
import 'shorts_event.dart';
import 'shorts_state.dart';

class ShortsBloc extends Bloc<ShortsEvent, ShortsState> {
  final GetShorts _getShorts;

  ShortsBloc({required GetShorts getShorts})
      : _getShorts = getShorts,
        super(const ShortsInitial()) {
    on<LoadShortsEvent>(_onLoad);
    on<LoadMoreShortsEvent>(_onLoadMore);
  }

  Future<void> _onLoad(LoadShortsEvent event, Emitter<ShortsState> emit) async {
    emit(const ShortsLoading());
    try {
      final (shorts, meta) = await _getShorts(page: 1);
      emit(ShortsLoaded(shorts: shorts, hasMore: meta.hasMore, page: 1));
    } catch (e) {
      emit(ShortsError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreShortsEvent event,
    Emitter<ShortsState> emit,
  ) async {
    final current = state;
    if (current is! ShortsLoaded || !current.hasMore) return;
    try {
      final nextPage = current.page + 1;
      final (shorts, meta) = await _getShorts(page: nextPage);
      emit(current.copyWith(
        shorts: [...current.shorts, ...shorts],
        hasMore: meta.hasMore,
        page: nextPage,
      ));
    } catch (_) {}
  }
}
