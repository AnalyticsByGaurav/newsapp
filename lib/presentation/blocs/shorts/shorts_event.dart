import 'package:equatable/equatable.dart';

abstract class ShortsEvent extends Equatable {
  const ShortsEvent();
  @override
  List<Object?> get props => [];
}

class LoadShortsEvent extends ShortsEvent {
  const LoadShortsEvent();
}

class LoadMoreShortsEvent extends ShortsEvent {
  const LoadMoreShortsEvent();
}
