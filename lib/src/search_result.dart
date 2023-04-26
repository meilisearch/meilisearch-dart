import 'package:meilisearch/src/searchable.dart';

class SearchResult<T> extends Searcheable<T> {
  const SearchResult({
    List<T>? hits,
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

  static SearchResult<Map<String, Object?>> fromMap(
    Map<String, Object?> map, {
    String? indexUid,
  }) {
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

  @override
  SearchResult<TOther> cast<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) {
    return SearchResult<TOther>(
      indexUid: indexUid,
      facetDistribution: facetDistribution,
      hits: hits?.map(mapper).toList(),
      estimatedTotalHits: estimatedTotalHits,
      limit: limit,
      offset: offset,
      matchesPosition: matchesPosition,
      processingTimeMs: processingTimeMs,
      query: query,
    );
  }
}
