import 'package:equatable/equatable.dart';
import '../../../domain/entities/short.dart';

abstract class ShortsState extends Equatable {
  const ShortsState();
  @override
  List<Object?> get props => [];
}

class ShortsInitial extends ShortsState {
  const ShortsInitial();
}

class ShortsLoading extends ShortsState {
  const ShortsLoading();
}

class ShortsLoaded extends ShortsState {
  final List<ShortVideo> shorts;
  final bool hasMore;
  final int page;

  const ShortsLoaded({
    required this.shorts,
    required this.hasMore,
    required this.page,
  });

  ShortsLoaded copyWith({List<ShortVideo>? shorts, bool? hasMore, int? page}) {
    return ShortsLoaded(
      shorts: shorts ?? this.shorts,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [shorts, hasMore, page];
}

class ShortsError extends ShortsState {
  final String message;
  const ShortsError({required this.message});
  @override
  List<Object?> get props => [message];
}
