part of 'base.dart';

class MeiliRankingScoreDetailsAttributeRule
    extends MeiliRankingScoreDetailsRuleBase {
  const MeiliRankingScoreDetailsAttributeRule._({
    required super.src,
    required super.order,
    required super.score,
    required this.attributeRankingOrderScore,
    required this.queryWordDistanceScore,
  });

  /// Score computed depending on the first attribute each word of the query appears in.
  /// The first attribute in the `searchableAttributes` list yields the highest score, the last attribute the lowest.
  final num attributeRankingOrderScore;

  /// Score computed depending on the position the attributes where each word of the query appears in.
  ///
  /// Words appearing in an attribute at the same position as in the query yield the highest score.
  ///
  /// The greater the distance to the position in the query, the lower the score.
  final num queryWordDistanceScore;

  factory MeiliRankingScoreDetailsAttributeRule.fromJson(
    Map<String, dynamic> src,
  ) =>
      MeiliRankingScoreDetailsAttributeRule._(
        src: src,
        order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
        score: MeiliRankingScoreDetailsRuleBase._readScore(src),
        attributeRankingOrderScore: src['attributeRankingOrderScore'] as num,
        queryWordDistanceScore: src['queryWordDistanceScore'] as num,
      );
}
