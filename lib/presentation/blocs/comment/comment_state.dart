import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {
  const CommentState();
  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {
  const CommentInitial();
}

class CaptchaLoading extends CommentState {
  const CaptchaLoading();
}

class CaptchaLoaded extends CommentState {
  final String question;
  final String token;

  const CaptchaLoaded({required this.question, required this.token});

  @override
  List<Object?> get props => [question, token];
}

class CommentSubmitting extends CommentState {
  const CommentSubmitting();
}

class CommentSubmitted extends CommentState {
  final String message;
  const CommentSubmitted({this.message = 'टिप्पणी सफलतापूर्वक पोस्ट की गई!'});
  @override
  List<Object?> get props => [message];
}

class CommentError extends CommentState {
  final String message;
  const CommentError({required this.message});
  @override
  List<Object?> get props => [message];
}
