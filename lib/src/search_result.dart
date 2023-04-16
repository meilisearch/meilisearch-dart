import 'package:meilisearch/src/searchable.dart';

class SearchResult extends Searcheable {
  const SearchResult({
    List<Map<String, Object?>>? hits,
    Object? facetDistribution,
    Object? matchesPosition,
    int? processingTimeMs,
    String? query,
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
        );

  /// Number of documents skipped
  final int? offset;

  /// Number of documents to take
  final int? limit;

  /// Estimated number of matches
  final int? estimatedTotalHits;

  factory SearchResult.fromMap(Map<String, Object?> map, {String? indexUid}) {
    return SearchResult(
      limit: map['limit'] as int?,
      offset: map['offset'] as int?,
      estimatedTotalHits: map['estimatedTotalHits'] as int?,
      hits: (map['hits'] as List?)?.cast<Map<String, Object?>>(),
      query: map['query'] as String?,
      processingTimeMs: map['processingTimeMs'] as int?,
      facetDistribution: map['facetDistribution'],
      matchesPosition: map['_matchesPosition'],
      indexUid: indexUid ?? map['indexUid'] as String,
    );
  }
}
