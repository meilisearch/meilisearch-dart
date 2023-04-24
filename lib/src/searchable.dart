import 'package:meilisearch/meilisearch.dart';

typedef MeilisearchDocumentMapper<TSrc, TOther> = TOther Function(TSrc src);

abstract class Searcheable<T> {
  final String indexUid;

  /// Query originating the response
  final String? query;

  /// Results of the query
  final List<T>? hits;

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

  static Searcheable<Map<String, Object?>> createSearchResult(
    Map<String, Object?> map, {
    String? indexUid,
  }) {
    if (map['totalHits'] != null) {
      return PaginatedSearchResult.fromMap(map, indexUid: indexUid);
    } else {
      return SearchResult.fromMap(map, indexUid: indexUid);
    }
  }

  Searcheable<TOther> cast<TOther>(MeilisearchDocumentMapper<T, TOther> mapper);

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
