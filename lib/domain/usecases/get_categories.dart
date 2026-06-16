import '../entities/category.dart';
import '../repositories/news_repository.dart';

class GetCategories {
  final NewsRepository repository;

  GetCategories(this.repository);

  Future<List<Category>> call() {
    return repository.getCategories();
  }
}
