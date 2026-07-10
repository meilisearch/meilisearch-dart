import '../annotations.dart';

/// Per-query federation options for multi-search.
///
/// Used within [IndexSearchQuery] to control how a specific query
/// participates in a federated search.
@RequiredMeiliServerVersion('1.10.0')
class FederationOptions {
  /// A multiplicative factor for ranking scores of search results
  /// in this specific query.
  ///
  /// If < 1.0, hits from this query are less likely to appear in
  /// the final results. If > 1.0, they are more likely.
  /// Must be a positive floating-point number. Defaults to 1.0.
  final double? weight;

  /// Indicates the remote instance where Meilisearch will perform the query.
  /// Must correspond to a configured remote object.
  final String? remote;

  const FederationOptions({
    this.weight,
    this.remote,
  });

  Map<String, Object?> toMap() => {
        if (weight != null) 'weight': weight,
        if (remote != null) 'remote': remote,
      };
}
