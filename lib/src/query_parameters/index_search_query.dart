import '../annotations.dart';
import '../filter_builder/_exports.dart';
import '../results/matching_strategy_enum.dart';
import 'hybrid_search.dart';
import 'search_query.dart';

@RequiredMeiliServerVersion('1.1.0')
class IndexSearchQuery extends SearchQuery {
  final String indexUid;
  final String? query;

  const IndexSearchQuery({
    required this.indexUid,
    this.query,
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
    super.attributesToSearchOn,
    super.hybrid,
    super.showRankingScore,
    super.vector,
    super.showRankingScoreDetails,
    super.rankingScoreThreshold,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'indexUid': indexUid,
      'q': query,
      ...super.buildMap(),
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
    List<String>? attributesToSearchOn,
    HybridSearch? hybrid,
    bool? showRankingScore,
    List<dynamic /* double | List<double> */ >? vector,
    bool? showRankingScoreDetails,
    double? rankingScoreThreshold,
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
        attributesToSearchOn: attributesToSearchOn ?? this.attributesToSearchOn,
        hybrid: hybrid ?? this.hybrid,
        showRankingScore: showRankingScore ?? this.showRankingScore,
        vector: vector ?? this.vector,
        showRankingScoreDetails:
            showRankingScoreDetails ?? this.showRankingScoreDetails,
        rankingScoreThreshold:
            rankingScoreThreshold ?? this.rankingScoreThreshold,
      );
}
