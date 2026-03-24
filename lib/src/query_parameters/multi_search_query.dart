import 'queryable.dart';

import '../annotations.dart';
import 'index_search_query.dart';

/// Federation options for multi-search requests.
@RequiredMeiliServerVersion('1.1.0')
class FederationOptions extends Queryable {
  /// The attribute to use for deduplication in federated search.
  final String? distinct;

  const FederationOptions({
    this.distinct,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'distinct': distinct,
    };
  }
}

@RequiredMeiliServerVersion('1.1.0')
class MultiSearchQuery extends Queryable {
  final List<IndexSearchQuery> queries;

  /// Federation options for the multi-search request.
  /// When provided, enables federated search.
  @RequiredMeiliServerVersion('1.40.0')
  final FederationOptions? federation;

  const MultiSearchQuery({
    required this.queries,
    this.federation,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'queries': queries.map((e) => e.toSparseMap()).toList(),
      'federation': federation?.toSparseMap(),
    };
  }
}
