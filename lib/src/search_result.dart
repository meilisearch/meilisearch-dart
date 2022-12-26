import 'package:meilisearch/src/searchable.dart';

class SearchResult extends Searcheable {
  SearchResult({
    this.offset,
    this.limit,
    this.estimatedTotalHits,
  });

  /// Number of documents skipped
  final int? offset;

  /// Number of documents to take
  final int? limit;

  /// Estimated number of matches
  final int? estimatedTotalHits;

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    var result = SearchResult(
      limit: map['limit'] as int?,
      offset: map['offset'] as int?,
      estimatedTotalHits: map['estimatedTotalHits'] as int?,
    );

    result.hits = (map['hits'] as List?)?.cast<Map<String, dynamic>>();
    result.query = map['query'] as String?;
    result.processingTimeMs = map['processingTimeMs'] as int?;
    result.facetDistribution = map['facetDistribution'] as dynamic;
    result.matchesPosition = map['_matchesPosition'] as dynamic;

    return result;
  }
}
