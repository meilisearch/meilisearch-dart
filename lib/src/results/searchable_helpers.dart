part of 'searchable.dart';

String _readIndexUid(Map<String, Object?> map) => map['indexUid'] as String;
String? _readQuery(Map<String, Object?> map) => map['query'] as String?;

int? _readProcessingTimeMs(Map<String, Object?> map) =>
    map['processingTimeMs'] as int?;

List<Map<String, dynamic>> _readHits(Map<String, Object?> map) =>
    (map['hits'] as List?)?.cast<Map<String, dynamic>>() ?? const [];

Map<String, FacetStat>? _readFacetStats(
  Map<String, Object?> map,
) {
  final facetStatsRaw = map['facetStats'] as Map<String, Object?>?;

  return facetStatsRaw?.map(
    (key, value) => MapEntry(
      key,
      FacetStat.fromMap(value as Map<String, Object?>),
    ),
  );
}

Map<String, Map<String, int>>? _readFacetDistribution(
  Map<String, Object?> map,
) {
  final src = map['facetDistribution'];

  if (src == null) return null;

  return (src as Map<String, Object?>).map(
    (key, value) => MapEntry(
      key,
      (value as Map<String, Object?>).cast<String, int>(),
    ),
  );
}



typedef MeilisearchDocumentMapper<TSrc, TOther> = TOther Function(TSrc src);

extension SearchableMapExt on Future<Searcheable<Map<String, dynamic>>> {
  Future<Searcheable<MeiliDocumentContainer<Map<String, dynamic>>>>
      mapToContainer() => then((value) => value.mapToContainer());
}

extension SearchResultMapExt on Future<SearchResult<Map<String, dynamic>>> {
  Future<SearchResult<MeiliDocumentContainer<Map<String, dynamic>>>>
      mapToContainer() => then((value) => value.mapToContainer());
}

extension PaginatedSearchResultMapExt
    on Future<PaginatedSearchResult<Map<String, dynamic>>> {
  Future<PaginatedSearchResult<MeiliDocumentContainer<Map<String, dynamic>>>>
      mapToContainer() => then((value) => value.mapToContainer());
}

extension SearchableExt<T> on Future<Searcheable<T>> {
  Future<PaginatedSearchResult<T>> asPaginatedResult() =>
      then((value) => value.asPaginatedResult());

  Future<SearchResult<T>> asSearchResult() =>
      then((value) => value.asSearchResult());

  Future<Searcheable<TOther>> map<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) =>
      then((value) => value.map(mapper));
}

extension SearchResultExt<T> on Future<SearchResult<T>> {
  Future<SearchResult<TOther>> map<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) =>
      then((value) => value.map(mapper));
}

extension PaginatedSearchResultExt<T> on Future<PaginatedSearchResult<T>> {
  Future<PaginatedSearchResult<TOther>> map<TOther>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) =>
      then((value) => value.map(mapper));
}
