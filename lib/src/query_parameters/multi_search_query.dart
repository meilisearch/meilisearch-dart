import 'index_search_query.dart';

class MultiSearchQuery {
  final List<IndexSearchQuery> queries;

  const MultiSearchQuery({
    required this.queries,
  });

  Map<String, Object?> toMap() {
    return {
      'queries': queries.map((e) => e.toMap()).toList(),
    };
  }
}
