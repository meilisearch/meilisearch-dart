import 'package:meilisearch/meilisearch.dart';

abstract class Searcheable {
  final String indexUid;

  /// Query originating the response
  final String? query;

  /// Results of the query
  final List<Map<String, Object?>>? hits;

  /// Distribution of the given facets
  final Object? facetDistribution;

  /// Contains the location of each occurrence of queried terms across all fields
  final Object? matchesPosition;

  /// Processing time of the query
  final int? processingTimeMs;

  const Searcheable({
    required this.indexUid,
    this.query,
    this.hits,
    this.facetDistribution,
    this.matchesPosition,
    this.processingTimeMs,
  });

  static Searcheable createSearchResult(Map<String, Object?> map,
      {String? indexUid}) {
    if (map['totalHits'] != null) {
      return PaginatedSearchResult.fromMap(map, indexUid: indexUid);
    } else {
      return SearchResult.fromMap(map, indexUid: indexUid);
    }
  }
}
