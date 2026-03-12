part of 'base.dart';

class MeiliRankingScoreDetailsAttributeRankRule
    extends MeiliRankingScoreDetailsRuleBase {
  const MeiliRankingScoreDetailsAttributeRankRule._({
    required super.src,
    required super.order,
    required super.score,
  });

  factory MeiliRankingScoreDetailsAttributeRankRule.fromJson(
    Map<String, dynamic> src,
  ) =>
      MeiliRankingScoreDetailsAttributeRankRule._(
        src: src,
        order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
        score: MeiliRankingScoreDetailsRuleBase._readScore(src),
      );
}
