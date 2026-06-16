import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? nameHi;
  final String slug;
  final String color;
  final int count;

  const Category({
    required this.id,
    required this.name,
    this.nameHi,
    required this.slug,
    this.color = '#c0392b',
    this.count = 0,
  });

  @override
  List<Object?> get props => [id, slug];
}
