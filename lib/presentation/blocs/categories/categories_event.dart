import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends CategoriesEvent {
  const LoadCategoriesEvent();
}

class SelectCategoryEvent extends CategoriesEvent {
  final String? slug;
  const SelectCategoryEvent(this.slug);
  @override
  List<Object?> get props => [slug];
}
