import 'filter_builder/_exports.dart';
import 'matching_strategy_enum.dart';

class SearchQuery {
  final String indexUid;
  final String? query;
  final int? offset;
  final int? limit;
  final int? page;
  final int? hitsPerPage;
  final Object? filter;
  final MeiliOperatorExpressionBase? filterExpression;
  final List<String>? sort;
  final List<String>? facets;
  final List<String>? attributesToRetrieve;
  final List<String>? attributesToCrop;
  final int? cropLength;
  final List<String>? attributesToHighlight;
  final bool? showMatchesPosition;
  final String? cropMarker;
  final String? highlightPreTag;
  final String? highlightPostTag;
  final MatchingStrategy? matchingStrategy;

  const SearchQuery({
    required this.query,
    required this.indexUid,
    this.offset,
    this.limit,
    this.page,
    this.hitsPerPage,
    this.filter,
    this.filterExpression,
    this.sort,
    this.facets,
    this.attributesToRetrieve,
    this.attributesToCrop,
    this.cropLength,
    this.attributesToHighlight,
    this.showMatchesPosition,
    this.cropMarker,
    this.highlightPreTag,
    this.highlightPostTag,
    this.matchingStrategy,
  });

  Map<String, Object> toMap() {
    return (<String, Object?>{
      'indexUid': indexUid,
      'q': query,
      'offset': offset,
      'limit': limit,
      'page': page,
      'hitsPerPage': hitsPerPage,
      'filter': filter ?? filterExpression?.transform(),
      'sort': sort,
      'facets': facets,
      'attributesToRetrieve': attributesToRetrieve,
      'attributesToCrop': attributesToCrop,
      'cropLength': cropLength,
      'attributesToHighlight': attributesToHighlight,
      'showMatchesPosition': showMatchesPosition,
      'cropMarker': cropMarker,
      'highlightPreTag': highlightPreTag,
      'highlightPostTag': highlightPostTag,
      'matchingStrategy': matchingStrategy?.name,
    }..removeWhere((key, value) => value == null))
        .cast<String, Object>();
  }
}
