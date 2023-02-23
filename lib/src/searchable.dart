import 'package:meilisearch/meilisearch.dart';

abstract class Searcheable {
  /// Query originating the response
  String? query;

  /// Results of the query
  List<Map<String, Object?>>? hits;

  /// Distribution of the given facets
  Object? facetDistribution;

  /// Contains the location of each occurrence of queried terms across all fields
  Object? matchesPosition;

  /// Processing time of the query
  int? processingTimeMs;

  static Searcheable createSearchResult(Map<String, Object?> map) {
    if (map['totalHits'] != null) {
      return PaginatedSearchResult.fromMap(map);
    } else {
      return SearchResult.fromMap(map);
    }
  }
}
