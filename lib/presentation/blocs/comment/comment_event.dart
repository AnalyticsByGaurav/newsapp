import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
  @override
  List<Object?> get props => [];
}

class LoadCaptchaEvent extends CommentEvent {
  const LoadCaptchaEvent();
}

class SubmitCommentEvent extends CommentEvent {
  final int articleId;
  final String name;
  final String email;
  final String content;
  final String captcha;
  final String captchaToken;

  const SubmitCommentEvent({
    required this.articleId,
    required this.name,
    required this.email,
    required this.content,
    required this.captcha,
    required this.captchaToken,
  });

  @override
  List<Object?> get props => [articleId, name, email, content];
}
