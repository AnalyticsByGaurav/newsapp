import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadEvent extends NewsEvent {
  final String? categorySlug;

  const HomeLoadEvent({this.categorySlug});

  @override
  List<Object?> get props => [categorySlug];
}

class HomeRefreshEvent extends NewsEvent {
  final String? categorySlug;

  const HomeRefreshEvent({this.categorySlug});

  @override
  List<Object?> get props => [categorySlug];
}

class HomeLoadMoreEvent extends NewsEvent {
  const HomeLoadMoreEvent();
}
