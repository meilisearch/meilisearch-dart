import 'serializer.dart';

class SearchResult<T> {
  SearchResult({
    this.hits,
    this.offset,
    this.limit,
    this.processingTimeMs,
    this.query,
    this.nbHits,
    this.exhaustiveNbHits,
    this.facetDistribution,
    this.exhaustiveFacetsCount,
  });

  /// Results of the query
  final List<T> hits;

  /// Number of documents skipped
  final int offset;

  /// Number of documents to take
  final int limit;

  /// Processing time of the query
  final int processingTimeMs;

  /// Total number of matches
  final int nbHits;

  /// Whether [nbHits] is exhaustive
  final bool exhaustiveNbHits;

  /// [Distribution of the given facets](https://docs.meilisearch.com/guides/advanced_guides/search_parameters.html#the-facets-distribution)
  final dynamic facetDistribution;

  /// Whether [facetDistribution] is exhaustive
  final bool exhaustiveFacetsCount;

  /// Query originating the response
  final String query;

  factory SearchResult.fromMap(
    Map<String, dynamic> map, {
    Serializer<T> serializer,
  }) {
    return SearchResult(
      hits: _deserializeHits(map, serializer: serializer),
      query: map['query'] as String,
      limit: map['limit'] as int,
      offset: map['offset'] as int,
      processingTimeMs: map['processingTimeMs'] as int,
      nbHits: map['nbHits'] as int,
      exhaustiveNbHits: map['exhaustiveNbHits'] as bool,
      facetDistribution: map['facetDistribution'],
      exhaustiveFacetsCount: map['exhaustiveFacetsCount'] as bool,
    );
  }
}

Type _typeof<T>() => T;

List<T> _deserializeHits<T>(
  Map<String, dynamic> map, {
  Serializer<T> serializer,
}) {
  if (serializer != null) {
    return (map['hits'] as List)
        .map((item) => serializer.deserialize(item))
        .cast<T>();
  } else if (T == dynamic || T == Map || T == _typeof<Map<String, dynamic>>()) {
    return (map['hits'] as List).cast<T>();
  } else {
    throw Exception(
      'You should either privide [serializer] argument or use '
      'Map<String, dynamic> generic type for parsing search results.',
    );
  }
}
