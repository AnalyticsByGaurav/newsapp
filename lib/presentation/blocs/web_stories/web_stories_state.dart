import 'package:equatable/equatable.dart';
import '../../../domain/entities/story.dart';

abstract class WebStoriesState extends Equatable {
  const WebStoriesState();
  @override
  List<Object?> get props => [];
}

class WebStoriesInitial extends WebStoriesState {
  const WebStoriesInitial();
}

class WebStoriesLoading extends WebStoriesState {
  const WebStoriesLoading();
}

class WebStoriesLoaded extends WebStoriesState {
  final List<WebStory> stories;
  final bool hasMore;
  final int page;

  const WebStoriesLoaded({
    required this.stories,
    required this.hasMore,
    required this.page,
  });

  WebStoriesLoaded copyWith({
    List<WebStory>? stories,
    bool? hasMore,
    int? page,
  }) {
    return WebStoriesLoaded(
      stories: stories ?? this.stories,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [stories, hasMore, page];
}

class WebStoriesError extends WebStoriesState {
  final String message;
  const WebStoriesError({required this.message});
  @override
  List<Object?> get props => [message];
}
