part of 'searchable.dart';

class PaginatedSearchResult<T> extends Searcheable<T> {
  const PaginatedSearchResult({
    List<T> hits = const [],
    Map<String, Map<String, int>>? facetDistribution,
    Map<String, List<MatchPosition>>? matchesPosition,
    int? processingTimeMs,
    String? query,
    Map<String, FacetStat>? facetStats,
    required String indexUid,
    this.hitsPerPage,
    this.page,
    this.totalHits,
    this.totalPages,
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
  final int? hitsPerPage;

  /// Number of documents to take
  final int? page;

  /// Total number of matches
  final int? totalHits;

  /// Total number of pages
  final int? totalPages;

  static PaginatedSearchResult<Map<String, dynamic>> fromMap(
    Map<String, Object?> map, {
    String? indexUid,
  }) {
    return PaginatedSearchResult(
      page: map['page'] as int?,
      hitsPerPage: map['hitsPerPage'] as int?,
      totalHits: map['totalHits'] as int?,
      totalPages: map['totalPages'] as int?,
      hits: _readHits(map),
      query: _readQuery(map),
      processingTimeMs: _readProcessingTimeMs(map),
      facetDistribution: _readFacetDistribution(map),
      matchesPosition: _readMatchesPosition(map),
      facetStats: _readFacetStats(map),
      indexUid: indexUid ?? _readIndexUid(map),
    );
  }

  @override
  PaginatedSearchResult<TOther> map<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) {
    return PaginatedSearchResult<TOther>(
      indexUid: indexUid,
      facetDistribution: facetDistribution,
      hits: hits.map(mapper).toList(),
      hitsPerPage: hitsPerPage,
      matchesPosition: matchesPosition,
      page: page,
      processingTimeMs: processingTimeMs,
      query: query,
      totalHits: totalHits,
      totalPages: totalPages,
    );
  }
}
