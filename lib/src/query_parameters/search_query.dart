import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/annotations.dart';
import 'queryable.dart';

class SearchQuery extends Queryable {
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
  final List<String>? attributesToSearchOn;
  @RequiredMeiliServerVersion('1.6.0')
  final HybridSearch? hybrid;
  @RequiredMeiliServerVersion('1.3.0')
  final bool? showRankingScore;
  @RequiredMeiliServerVersion('1.3.0')
  final bool? showRankingScoreDetails;
  @RequiredMeiliServerVersion('1.9.0')
  final double? rankingScoreThreshold;
  @RequiredMeiliServerVersion('1.3.0')
  final List<dynamic /* double | List<double> */ >? vector;
  @RequiredMeiliServerVersion('1.35.0')
  final bool? showPerformanceDetails;

  const SearchQuery({
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
    this.attributesToSearchOn,
    this.hybrid,
    this.showRankingScore,
    this.showRankingScoreDetails,
    this.rankingScoreThreshold,
    this.vector,
    this.showPerformanceDetails,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
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
      'attributesToSearchOn': attributesToSearchOn,
      'hybrid': hybrid?.toMap(),
      'showRankingScore': showRankingScore,
      'showRankingScoreDetails': showRankingScoreDetails,
      'rankingScoreThreshold': rankingScoreThreshold,
      'vector': vector,
      'showPerformanceDetails': showPerformanceDetails,
    };
  }

  SearchQuery copyWith({
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
    List<dynamic>? vector,
    bool? showRankingScoreDetails,
    double? rankingScoreThreshold,
    bool? showPerformanceDetails,
  }) =>
      SearchQuery(
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
        showPerformanceDetails:
            showPerformanceDetails ?? this.showPerformanceDetails,
      );
}
