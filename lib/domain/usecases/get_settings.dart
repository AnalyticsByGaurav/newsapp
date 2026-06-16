import '../entities/site_settings.dart';
import '../repositories/news_repository.dart';

class GetSettings {
  final NewsRepository repository;

  GetSettings(this.repository);

  Future<SiteSettings> call() {
    return repository.getSettings();
  }
}
