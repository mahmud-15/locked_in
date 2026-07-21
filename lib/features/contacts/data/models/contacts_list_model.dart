class PaginationMeta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  const PaginationMeta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
    total: json['total'] as int? ?? 0,
    limit: json['limit'] as int? ?? 10,
    page: json['page'] as int? ?? 1,
    totalPage: json['totalPage'] as int? ?? 1,
  );
}
