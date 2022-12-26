import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/paginated_search_result.dart';

abstract class Searcheable {
  /// Query originating the response
  String? query;

  /// Results of the query
  List<Map<String, dynamic>>? hits;

  /// Distribution of the given facets
  dynamic facetDistribution;

  /// Contains the location of each occurrence of queried terms across all fields
  dynamic matchesPosition;

  /// Processing time of the query
  int? processingTimeMs;

  static Searcheable createSearchResult(Map<String, dynamic> map) {
    if (map['totalHits'] != null) {
      return PaginatedSearchResult.fromMap(map);
    } else {
      return SearchResult.fromMap(map);
    }
  }
}
