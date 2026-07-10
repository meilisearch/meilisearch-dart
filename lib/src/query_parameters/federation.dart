import '../annotations.dart';

/// Top-level federation configuration for multi-search.
///
/// When present in a [MultiSearchQuery], Meilisearch returns a single,
/// merged list of results ordered by descending ranking score.
@RequiredMeiliServerVersion('1.10.0')
class Federation {
  /// Number of results to skip in the merged list.
  final int? offset;

  /// Maximum number of results to return in the merged list.
  final int? limit;

  /// Request facet distributions per index.
  /// Keys are index UIDs, values are lists of attribute names.
  final Map<String, List<String>>? facetsByIndex;

  /// When true, facet information from all queried indexes is merged
  /// into a single object in the response.
  final bool? mergeFacets;

  const Federation({
    this.offset,
    this.limit,
    this.facetsByIndex,
    this.mergeFacets,
  });

  Map<String, Object?> toMap() => {
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (facetsByIndex != null) 'facetsByIndex': facetsByIndex,
        if (mergeFacets != null) 'mergeFacets': mergeFacets,
      };
}
