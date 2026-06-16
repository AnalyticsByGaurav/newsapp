import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.nameHi,
    required super.slug,
    super.color,
    super.count,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      nameHi: json['name_hi']?.toString(),
      slug: json['slug']?.toString() ?? '',
      color: json['color']?.toString() ?? '#c0392b',
      count: (json['article_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_hi': nameHi,
        'slug': slug,
        'color': color,
        'article_count': count,
      };
}
