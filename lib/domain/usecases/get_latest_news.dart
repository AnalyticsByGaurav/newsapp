import '../entities/article.dart';
import '../entities/pagination_meta.dart';
import '../repositories/news_repository.dart';

class GetLatestNewsParams {
  final int page;
  final int perPage;
  final String? categorySlug;

  const GetLatestNewsParams({
    this.page = 1,
    this.perPage = 15,
    this.categorySlug,
  });
}

class GetLatestNews {
  final NewsRepository repository;

  GetLatestNews(this.repository);

  Future<(List<Article>, PaginationMeta)> call(GetLatestNewsParams params) {
    return repository.getLatestNews(
      page: params.page,
      perPage: params.perPage,
      categorySlug: params.categorySlug,
    );
  }
}
