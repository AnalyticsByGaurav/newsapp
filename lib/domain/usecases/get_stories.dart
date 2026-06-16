import '../entities/story.dart';
import '../entities/pagination_meta.dart';
import '../repositories/news_repository.dart';

class GetWebStories {
  final NewsRepository repository;

  GetWebStories(this.repository);

  Future<(List<WebStory>, PaginationMeta)> call({int page = 1}) {
    return repository.getWebStories(page: page);
  }
}
