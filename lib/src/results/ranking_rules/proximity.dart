part of 'base.dart';

class MeiliRankingScoreDetailsProximityRule
    extends MeiliRankingScoreDetailsRuleBase {
  const MeiliRankingScoreDetailsProximityRule._({
    required super.src,
    required super.order,
    required super.score,
  });

  factory MeiliRankingScoreDetailsProximityRule.fromJson(
    Map<String, dynamic> src,
  ) {
    return MeiliRankingScoreDetailsProximityRule._(
      src: src,
      order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
      score: MeiliRankingScoreDetailsRuleBase._readScore(src),
    );
  }
}
