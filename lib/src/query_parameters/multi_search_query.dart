import 'queryable.dart';

import '../annotations.dart';
import 'index_search_query.dart';

@RequiredMeiliServerVersion('1.1.0')
class MultiSearchQuery extends Queryable {
  final List<IndexSearchQuery> queries;

  const MultiSearchQuery({
    required this.queries,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'queries': queries.map((e) => e.toSparseMap()).toList(),
    };
  }
}
