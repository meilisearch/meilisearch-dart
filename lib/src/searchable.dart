import 'package:meilisearch/meilisearch.dart';

part 'search_result.dart';
part 'paginated_search_result.dart';
part 'searchable_helpers.dart';

abstract class Searcheable<T> {
  final String indexUid;

  /// Query originating the response
  final String? query;

  /// Results of the query
  final List<T> hits;

  /// Distribution of the given facets
  final Map<String, Map<String, int>>? facetDistribution;

  /// Distribution of the given facets
  final Map<String, FacetStat>? facetStats;

  /// Contains the location of each occurrence of queried terms across all fields
  final Map<String, List<MatchPosition>>? matchesPosition;

  /// Processing time of the query
  final int? processingTimeMs;

  const Searcheable({
    required this.indexUid,
    this.query,
    this.hits = const [],
    this.facetDistribution,
    this.matchesPosition,
    this.processingTimeMs,
    this.facetStats,
  });

  static Searcheable<Map<String, dynamic>> createSearchResult(
    Map<String, Object?> map, {
    String? indexUid,
  }) {
    if (map['totalHits'] != null) {
      return PaginatedSearchResult.fromMap(map, indexUid: indexUid);
    } else {
      return SearchResult.fromMap(map, indexUid: indexUid);
    }
  }

  Searcheable<TOther> map<TOther>(MeilisearchDocumentMapper<T, TOther> mapper);

  PaginatedSearchResult<T> asPaginatedResult() {
    final src = this;
    assert(src is PaginatedSearchResult<T>);
    return src as PaginatedSearchResult<T>;
  }

  SearchResult<T> asSearchResult() {
    final src = this;
    assert(src is SearchResult<T>);
    return src as SearchResult<T>;
  }
}
