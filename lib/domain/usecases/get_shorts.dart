import '../entities/short.dart';
import '../entities/pagination_meta.dart';
import '../repositories/news_repository.dart';

class GetShorts {
  final NewsRepository repository;

  GetShorts(this.repository);

  Future<(List<ShortVideo>, PaginationMeta)> call({int page = 1}) {
    return repository.getShorts(page: page);
  }
}
