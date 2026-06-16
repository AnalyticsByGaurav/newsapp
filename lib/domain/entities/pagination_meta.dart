import 'package:equatable/equatable.dart';

class PaginationMeta extends Equatable {
  final int page;
  final int perPage;
  final int total;

  const PaginationMeta({
    required this.page,
    required this.perPage,
    required this.total,
  });

  int get totalPages => perPage > 0 ? (total / perPage).ceil() : 0;
  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [page, perPage, total];
}
