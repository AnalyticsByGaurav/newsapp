import 'package:equatable/equatable.dart';

abstract class WebStoriesEvent extends Equatable {
  const WebStoriesEvent();
  @override
  List<Object?> get props => [];
}

class LoadWebStoriesEvent extends WebStoriesEvent {
  const LoadWebStoriesEvent();
}

class LoadMoreWebStoriesEvent extends WebStoriesEvent {
  const LoadMoreWebStoriesEvent();
}
