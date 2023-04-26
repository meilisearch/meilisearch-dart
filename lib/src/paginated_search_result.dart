import 'package:meilisearch/src/searchable.dart';

class PaginatedSearchResult<T> extends Searcheable<T> {
  const PaginatedSearchResult({
    List<T>? hits,
    Object? facetDistribution,
    Object? matchesPosition,
    int? processingTimeMs,
    String? query,
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
        );

  /// Number of documents skipped
  final int? hitsPerPage;

  /// Number of documents to take
  final int? page;

  /// Total number of matches
  final int? totalHits;

  /// Total number of pages
  final int? totalPages;

  static PaginatedSearchResult<Map<String, Object?>> fromMap(
    Map<String, Object?> map, {
    String? indexUid,
  }) {
    return PaginatedSearchResult(
      page: map['page'] as int?,
      hitsPerPage: map['hitsPerPage'] as int?,
      totalHits: map['totalHits'] as int?,
      totalPages: map['totalPages'] as int?,
      hits: (map['hits'] as List?)?.cast<Map<String, Object?>>(),
      query: map['query'] as String?,
      processingTimeMs: map['processingTimeMs'] as int?,
      facetDistribution: map['facetDistribution'],
      matchesPosition: map['_matchesPosition'],
      indexUid: indexUid ?? map['indexUid'] as String,
    );
  }

  @override
  PaginatedSearchResult<TOther> cast<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) {
    return PaginatedSearchResult<TOther>(
      indexUid: indexUid,
      facetDistribution: facetDistribution,
      hits: hits?.map(mapper).toList(),
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
