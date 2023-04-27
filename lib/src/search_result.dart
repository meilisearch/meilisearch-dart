part of 'searchable.dart';

class SearchResult<T> extends Searcheable<T> {
  const SearchResult({
    List<T> hits = const [],
    Map<String, Map<String, int>>? facetDistribution,
    Map<String, List<MatchPosition>>? matchesPosition,
    int? processingTimeMs,
    String? query,
    Map<String, FacetStat>? facetStats,
    required String indexUid,
    this.offset,
    this.limit,
    this.estimatedTotalHits,
  }) : super(
          facetDistribution: facetDistribution,
          hits: hits,
          matchesPosition: matchesPosition,
          processingTimeMs: processingTimeMs,
          query: query,
          indexUid: indexUid,
          facetStats: facetStats,
        );

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
      limit: map['limit'] as int?,
      offset: map['offset'] as int?,
      estimatedTotalHits: map['estimatedTotalHits'] as int?,
      hits: _readHits(map),
      query: _readQuery(map),
      processingTimeMs: _readProcessingTimeMs(map),
      facetDistribution: _readFacetDistribution(map),
      matchesPosition: _readMatchesPosition(map),
      indexUid: indexUid ?? _readIndexUid(map),
      facetStats: _readFacetStats(map),
    );
  }

  @override
  SearchResult<TOther> map<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) {
    return SearchResult<TOther>(
      indexUid: indexUid,
      facetDistribution: facetDistribution,
      hits: hits.map(mapper).toList(),
      estimatedTotalHits: estimatedTotalHits,
      limit: limit,
      offset: offset,
      matchesPosition: matchesPosition,
      processingTimeMs: processingTimeMs,
      query: query,
    );
  }
}
