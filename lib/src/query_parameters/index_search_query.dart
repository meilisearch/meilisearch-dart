import '../filter_builder/_exports.dart';
import '../matching_strategy_enum.dart';
import 'search_query.dart';

class IndexSearchQuery extends SearchQuery {
  final String indexUid;

  const IndexSearchQuery({
    required this.indexUid,
    required super.query,
    super.offset,
    super.limit,
    super.page,
    super.hitsPerPage,
    super.filter,
    super.filterExpression,
    super.sort,
    super.facets,
    super.attributesToRetrieve,
    super.attributesToCrop,
    super.cropLength,
    super.attributesToHighlight,
    super.showMatchesPosition,
    super.cropMarker,
    super.highlightPreTag,
    super.highlightPostTag,
    super.matchingStrategy,
  });

  @override
  Map<String, Object> toMap() {
    return {
      'indexUid': indexUid,
      ...super.toMap(),
    };
  }

  @override
  IndexSearchQuery copyWith({
    String? indexUid,
    String? query,
    int? offset,
    int? limit,
    int? page,
    int? hitsPerPage,
    Object? filter,
    MeiliOperatorExpressionBase? filterExpression,
    List<String>? sort,
    List<String>? facets,
    List<String>? attributesToRetrieve,
    List<String>? attributesToCrop,
    int? cropLength,
    List<String>? attributesToHighlight,
    bool? showMatchesPosition,
    String? cropMarker,
    String? highlightPreTag,
    String? highlightPostTag,
    MatchingStrategy? matchingStrategy,
  }) =>
      IndexSearchQuery(
        query: query ?? this.query,
        indexUid: indexUid ?? this.indexUid,
        offset: offset ?? this.offset,
        limit: limit ?? this.limit,
        page: page ?? this.page,
        hitsPerPage: hitsPerPage ?? this.hitsPerPage,
        filter: filter ?? this.filter,
        filterExpression: filterExpression ?? this.filterExpression,
        sort: sort ?? this.sort,
        facets: facets ?? this.facets,
        attributesToRetrieve: attributesToRetrieve ?? this.attributesToRetrieve,
        attributesToCrop: attributesToCrop ?? this.attributesToCrop,
        cropLength: cropLength ?? this.cropLength,
        attributesToHighlight:
            attributesToHighlight ?? this.attributesToHighlight,
        showMatchesPosition: showMatchesPosition ?? this.showMatchesPosition,
        cropMarker: cropMarker ?? this.cropMarker,
        highlightPreTag: highlightPreTag ?? this.highlightPreTag,
        highlightPostTag: highlightPostTag ?? this.highlightPostTag,
        matchingStrategy: matchingStrategy ?? this.matchingStrategy,
      );
}
