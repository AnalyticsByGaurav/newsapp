import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int count;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.count = 0,
  });

  @override
  List<Object?> get props => [id, slug];
}
