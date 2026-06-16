import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final String? selectedSlug;

  const CategoriesLoaded({required this.categories, this.selectedSlug});

  CategoriesLoaded copyWith({List<Category>? categories, String? selectedSlug}) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      selectedSlug: selectedSlug,
    );
  }

  @override
  List<Object?> get props => [categories, selectedSlug];
}

class CategoriesError extends CategoriesState {
  final String message;
  const CategoriesError({required this.message});
  @override
  List<Object?> get props => [message];
}
