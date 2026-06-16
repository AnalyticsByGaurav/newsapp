import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/comment.dart';
import '../../../domain/usecases/get_captcha.dart';
import '../../../domain/usecases/post_comment.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetCaptcha _getCaptcha;
  final PostComment _postComment;

  CommentBloc({required GetCaptcha getCaptcha, required PostComment postComment})
      : _getCaptcha = getCaptcha,
        _postComment = postComment,
        super(const CommentInitial()) {
    on<LoadCaptchaEvent>(_onLoadCaptcha);
    on<SubmitCommentEvent>(_onSubmit);
  }

  Future<void> _onLoadCaptcha(
    LoadCaptchaEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(const CaptchaLoading());
    try {
      final captcha = await _getCaptcha();
      emit(CaptchaLoaded(question: captcha.question, token: captcha.token));
    } catch (e) {
      emit(CommentError(message: e.toString()));
    }
  }

  Future<void> _onSubmit(
    SubmitCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(const CommentSubmitting());
    try {
      await _postComment(CommentRequest(
        articleId: event.articleId,
        name: event.name,
        email: event.email,
        content: event.content,
        captcha: event.captcha,
        captchaToken: event.captchaToken,
      ));
      emit(const CommentSubmitted());
    } catch (e) {
      emit(CommentError(message: e.toString()));
    }
  }
}
