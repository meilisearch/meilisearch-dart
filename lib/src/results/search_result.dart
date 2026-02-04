part of 'searchable.dart';

/// Represents an offset-based search result
class SearchResult<T> extends Searcheable<T> {
  const SearchResult({
    required super.src,
    required super.indexUid,
    required super.hits,
    required super.facetDistribution,
    required super.processingTimeMs,
    required super.query,
    required super.facetStats,
    required super.vector,
    required super.performanceDetails,
    required this.offset,
    required this.limit,
    required this.estimatedTotalHits,
  });

  /// Number of documents skipped
  final int? offset;

  /// Number of documents to take
  final int? limit;

  /// Estimated number of matches
  final int? estimatedTotalHits;

  static SearchResult<Map<String, dynamic>> fromMap(
    Map<String, Object?> map, {
    String? indexUid,
  }) {
    return SearchResult(
      src: map,
      vector: map['vector'] as List?,
      limit: map['limit'] as int?,
      offset: map['offset'] as int?,
      estimatedTotalHits: map['estimatedTotalHits'] as int?,
      hits: _readHits(map),
      query: _readQuery(map),
      processingTimeMs: _readProcessingTimeMs(map),
      facetDistribution: _readFacetDistribution(map),
      indexUid: indexUid ?? _readIndexUid(map),
      facetStats: _readFacetStats(map),
      performanceDetails: _readPerformanceDetails(map),
    );
  }

  @override
  SearchResult<TOther> map<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) =>
      SearchResult<TOther>(
        src: src,
        facetStats: facetStats,
        vector: vector,
        indexUid: indexUid,
        facetDistribution: facetDistribution,
        hits: hits.map(mapper).toList(),
        estimatedTotalHits: estimatedTotalHits,
        limit: limit,
        offset: offset,
        processingTimeMs: processingTimeMs,
        query: query,
        performanceDetails: performanceDetails,
      );
}
