part of 'searchable.dart';

class PaginatedSearchResult<T> extends Searcheable<T> {
  const PaginatedSearchResult({
    required super.src,
    required super.indexUid,
    required super.hits,
    required super.facetDistribution,
    required super.processingTimeMs,
    required super.query,
    required super.facetStats,
    required super.vector,
    required this.hitsPerPage,
    required this.page,
    required this.totalHits,
    required this.totalPages,
  });

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
      src: map,
      page: map['page'] as int?,
      hitsPerPage: map['hitsPerPage'] as int?,
      totalHits: map['totalHits'] as int?,
      totalPages: map['totalPages'] as int?,
      hits: _readHits(map),
      query: _readQuery(map),
      processingTimeMs: _readProcessingTimeMs(map),
      facetDistribution: _readFacetDistribution(map),
      facetStats: _readFacetStats(map),
      indexUid: indexUid ?? _readIndexUid(map),
      vector: map['vector'] as List?,
    );
  }

  @override
  PaginatedSearchResult<TOther> map<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) {
    return PaginatedSearchResult<TOther>(
      facetStats: facetStats,
      src: src,
      indexUid: indexUid,
      vector: vector,
      facetDistribution: facetDistribution,
      hits: hits.map(mapper).toList(),
      hitsPerPage: hitsPerPage,
      page: page,
      processingTimeMs: processingTimeMs,
      query: query,
      totalHits: totalHits,
      totalPages: totalPages,
    );
  }
}
