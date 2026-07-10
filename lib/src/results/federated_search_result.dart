import 'facet_stat.dart';

/// Represents the result of a federated multi-search.
///
/// When [Federation] is passed to [MultiSearchQuery], Meilisearch returns
/// a single merged list of hits instead of per-query result objects.
/// Each hit includes a `_federation` map with `indexUid` and `queriesPosition`.
class FederatedSearchResult {
  /// Merged list of hits from all queried indexes.
  ///
  /// Each hit contains a `_federation` key with `indexUid` (the source index)
  /// and `queriesPosition` (the index of the originating query).
  final List<Map<String, dynamic>> hits;

  /// Processing time in milliseconds.
  final int? processingTimeMs;

  /// Number of results to skip.
  final int? offset;

  /// Maximum number of results returned.
  final int? limit;

  /// Estimated total number of hits across all queries.
  final int? estimatedTotalHits;

  /// Number of hits from semantic search.
  final int? semanticHitCount;

  /// Per-index facet distributions (when `facetsByIndex` is used).
  final Map<String, Map<String, Map<String, int>>>? facetsByIndex;

  /// Merged facet distribution (when `mergeFacets` is true).
  final Map<String, Map<String, int>>? facetDistribution;

  /// Merged facet stats (when `mergeFacets` is true).
  final Map<String, FacetStat>? facetStats;

  const FederatedSearchResult({
    required this.hits,
    this.processingTimeMs,
    this.offset,
    this.limit,
    this.estimatedTotalHits,
    this.semanticHitCount,
    this.facetsByIndex,
    this.facetDistribution,
    this.facetStats,
  });

  factory FederatedSearchResult.fromMap(Map<String, Object?> map) {
    return FederatedSearchResult(
      hits: (map['hits'] as List?)?.cast<Map<String, dynamic>>() ?? const [],
      processingTimeMs: map['processingTimeMs'] as int?,
      offset: map['offset'] as int?,
      limit: map['limit'] as int?,
      estimatedTotalHits: map['estimatedTotalHits'] as int?,
      semanticHitCount: map['semanticHitCount'] as int?,
      facetsByIndex: _readFacetsByIndex(map),
      facetDistribution: _readFacetDistribution(map),
      facetStats: _readFacetStats(map),
    );
  }

  static Map<String, Map<String, Map<String, int>>>? _readFacetsByIndex(
    Map<String, Object?> map,
  ) {
    final raw = map['facetsByIndex'] as Map<String, Object?>?;
    if (raw == null) return null;

    return raw.map(
      (indexUid, indexFacets) {
        final facetMap = (indexFacets as Map<String, Object?>);
        final distribution =
            (facetMap['distribution'] as Map<String, Object?>?)?.map(
                  (key, value) => MapEntry(
                    key,
                    (value as Map<String, Object?>).cast<String, int>(),
                  ),
                ) ??
                {};
        return MapEntry(indexUid, distribution);
      },
    );
  }

  static Map<String, Map<String, int>>? _readFacetDistribution(
    Map<String, Object?> map,
  ) {
    final src = map['facetDistribution'];
    if (src == null) return null;

    return (src as Map<String, Object?>).map(
      (key, value) => MapEntry(
        key,
        (value as Map<String, Object?>).cast<String, int>(),
      ),
    );
  }

  static Map<String, FacetStat>? _readFacetStats(
    Map<String, Object?> map,
  ) {
    final raw = map['facetStats'] as Map<String, Object?>?;
    if (raw == null) return null;

    return raw.map(
      (key, value) => MapEntry(
        key,
        FacetStat.fromMap(value as Map<String, Object?>),
      ),
    );
  }
}
