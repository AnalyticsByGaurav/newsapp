import '../repositories/news_repository.dart';

class GetCaptcha {
  final NewsRepository repository;

  GetCaptcha(this.repository);

  Future<({String question, String token})> call() {
    return repository.getCaptcha();
  }
}
