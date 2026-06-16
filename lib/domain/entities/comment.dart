import 'package:equatable/equatable.dart';

class CommentRequest extends Equatable {
  final int articleId;
  final String name;
  final String email;
  final String content;
  final String captcha;
  final String captchaToken;

  const CommentRequest({
    required this.articleId,
    required this.name,
    required this.email,
    required this.content,
    required this.captcha,
    required this.captchaToken,
  });

  @override
  List<Object?> get props => [articleId, name, email, content, captcha, captchaToken];
}
