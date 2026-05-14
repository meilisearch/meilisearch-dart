part of 'base.dart';

class MeiliRankingScoreDetailsWordPositionRule
    extends MeiliRankingScoreDetailsRuleBase {
  const MeiliRankingScoreDetailsWordPositionRule._({
    required super.src,
    required super.order,
    required super.score,
  });

  factory MeiliRankingScoreDetailsWordPositionRule.fromJson(
    Map<String, dynamic> src,
  ) =>
      MeiliRankingScoreDetailsWordPositionRule._(
        src: src,
        order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
        score: MeiliRankingScoreDetailsRuleBase._readScore(src),
      );
}
