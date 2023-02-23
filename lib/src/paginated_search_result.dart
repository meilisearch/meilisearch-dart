import 'package:meilisearch/src/searchable.dart';

class PaginatedSearchResult extends Searcheable {
  PaginatedSearchResult({
    this.hitsPerPage,
    this.page,
    this.totalHits,
    this.totalPages,
  });

  /// Number of documents skipped
  final int? hitsPerPage;

  /// Number of documents to take
  final int? page;

  /// Total number of matches
  final int? totalHits;

  /// Total number of pages
  final int? totalPages;

  factory PaginatedSearchResult.fromMap(Map<String, Object?> map) {
    var result = PaginatedSearchResult(
      page: map['page'] as int?,
      hitsPerPage: map['hitsPerPage'] as int?,
      totalHits: map['totalHits'] as int?,
      totalPages: map['totalPages'] as int?,
    );

    result.hits = (map['hits'] as List?)?.cast<Map<String, Object?>>();
    result.query = map['query'] as String?;
    result.processingTimeMs = map['processingTimeMs'] as int?;
    result.facetDistribution = map['facetDistribution'];
    result.matchesPosition = map['_matchesPosition'];

    return result;
  }
}
