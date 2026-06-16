import '../entities/comment.dart';
import '../repositories/news_repository.dart';

class PostComment {
  final NewsRepository repository;

  PostComment(this.repository);

  Future<void> call(CommentRequest request) {
    return repository.postComment(request);
  }
}
