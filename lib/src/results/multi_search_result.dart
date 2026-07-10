import 'federated_search_result.dart';
import 'searchable.dart';

class MultiSearchResult {
  /// Per-query results (non-federated multi-search).
  /// This is `null` when federation is used.
  final List<Searcheable<Map<String, Object?>>>? results;

  /// Merged federated result (federated multi-search).
  /// This is `null` when federation is not used.
  final FederatedSearchResult? federated;

  const MultiSearchResult({
    this.results,
    this.federated,
  });

  factory MultiSearchResult.fromMap(Map<String, Object?> json) {
    // When federation is used, the response has 'hits' at the top level
    // instead of 'results'.
    if (json.containsKey('results')) {
      final list = json['results'] as List<Object?>;
      final parsed = list
          .cast<Map<String, Object?>>()
          .map((e) => Searcheable.createSearchResult(e));

      return MultiSearchResult(results: parsed.toList());
    } else {
      return MultiSearchResult(
        federated: FederatedSearchResult.fromMap(json),
      );
    }
  }
}
