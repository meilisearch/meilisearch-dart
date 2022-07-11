class SearchResult {
  SearchResult({
    this.hits,
    this.offset,
    this.limit,
    this.processingTimeMs,
    this.query,
    this.estimatedTotalHits,
    this.facetDistribution,
  });

  /// Results of the query
  final List<Map<String, dynamic>>? hits;

  /// Number of documents skipped
  final int? offset;

  /// Number of documents to take
  final int? limit;

  /// Processing time of the query
  final int? processingTimeMs;

  /// Total number of matches
  final int? estimatedTotalHits;

  /// Distribution of the given facets
  final dynamic facetDistribution;

  /// Query originating the response
  final String? query;

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      hits: (map['hits'] as List?)?.cast<Map<String, dynamic>>(),
      query: map['query'] as String?,
      limit: map['limit'] as int?,
      offset: map['offset'] as int?,
      processingTimeMs: map['processingTimeMs'] as int?,
      estimatedTotalHits: map['estimatedTotalHits'] as int?,
      facetDistribution: map['facetDistribution'] as dynamic,
    );
  }
}
