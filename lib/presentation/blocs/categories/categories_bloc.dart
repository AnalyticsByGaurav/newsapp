import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_categories.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategories _getCategories;

  CategoriesBloc({required GetCategories getCategories})
      : _getCategories = getCategories,
        super(const CategoriesInitial()) {
    on<LoadCategoriesEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoading());
    try {
      final categories = await _getCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }
}
