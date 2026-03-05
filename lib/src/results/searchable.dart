import 'package:meilisearch/meilisearch.dart';

part 'search_result.dart';
part 'paginated_search_result.dart';
part 'searchable_helpers.dart';

/// Represents a search result.
///
/// Can be one of:
/// - [SearchResult] if offset, limit are used.
/// - [PaginatedSearchResult] if page, hitsPerPage are used.
abstract class Searcheable<T> {
  final Map<String, dynamic> src;

  final String indexUid;

  /// Query originating the response
  final String? query;

  /// Results of the query
  final List<T> hits;

  /// Distribution of the given facets
  final Map<String, Map<String, int>>? facetDistribution;

  /// Distribution of the given facets
  final Map<String, FacetStat>? facetStats;

  /// Processing time of the query
  final int? processingTimeMs;
  final List<dynamic /*double | List<double>*/ >? vector;

  /// Performance details of the query, available when `showPerformanceDetails` is set to `true`.
  final Map<String, dynamic>? performanceDetails;

  const Searcheable({
    required this.src,
    required this.indexUid,
    required this.query,
    required this.hits,
    required this.facetDistribution,
    required this.processingTimeMs,
    required this.facetStats,
    required this.vector,
    required this.performanceDetails,
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

extension MapSearcheable on Searcheable<Map<String, dynamic>> {
  Searcheable<MeiliDocumentContainer<Map<String, dynamic>>> mapToContainer() =>
      map(MeiliDocumentContainer.fromJson);
}

extension MapSearcheableSearchResult on SearchResult<Map<String, dynamic>> {
  SearchResult<MeiliDocumentContainer<Map<String, dynamic>>> mapToContainer() =>
      map(MeiliDocumentContainer.fromJson);
}

extension MapSearcheablePaginatedSearchResult
    on PaginatedSearchResult<Map<String, dynamic>> {
  PaginatedSearchResult<MeiliDocumentContainer<Map<String, dynamic>>>
      mapToContainer() => map(MeiliDocumentContainer.fromJson);
}
