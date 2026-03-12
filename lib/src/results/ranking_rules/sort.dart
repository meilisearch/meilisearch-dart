part of 'base.dart';

class MeiliRankingScoreDetailsSortRule {
  /// The source json object this was created from.
  final Map<String, dynamic> src;

  /// The order that this ranking rule was applied.
  final int order;

  /// The value that was used for sorting this document.
  final dynamic value;

  /// Sort rules do not affect relevance and therefore do not always expose a score.
  final num? score;

  const MeiliRankingScoreDetailsSortRule({
    required this.src,
    required this.order,
    required this.value,
    required this.score,
  });

  factory MeiliRankingScoreDetailsSortRule.fromJson(Map<String, dynamic> src) =>
      MeiliRankingScoreDetailsSortRule(
        src: src,
        order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
        score: src['score'] as num?,
        value: src['value'],
      );
}
