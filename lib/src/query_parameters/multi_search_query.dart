import 'queryable.dart';

import '../annotations.dart';
import 'federation.dart';
import 'index_search_query.dart';

@RequiredMeiliServerVersion('1.1.0')
class MultiSearchQuery extends Queryable {
  final List<IndexSearchQuery> queries;

  /// When present, Meilisearch returns a single merged list of results
  /// ordered by descending ranking score (federated search).
  ///
  /// Pass an empty [Federation] object (e.g. `Federation()`) to enable
  /// federated search with default settings.
  @RequiredMeiliServerVersion('1.10.0')
  final Federation? federation;

  const MultiSearchQuery({
    required this.queries,
    this.federation,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'queries': queries.map((e) => e.toSparseMap()).toList(),
      if (federation != null) 'federation': federation!.toMap(),
    };
  }
}
