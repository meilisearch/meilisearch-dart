import 'search_query.dart';

class MultiSearchQuery {
  final List<SearchQuery> queries;

  const MultiSearchQuery({
    required this.queries,
  });

  Map<String, Object?> toMap() {
    return {
      'queries': queries.map((e) => e.toMap()).toList()
    };
  }
}
