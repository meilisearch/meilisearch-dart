part of 'base.dart';

class MeiliRankingScoreDetailsExactnessRule
    extends MeiliRankingScoreDetailsRuleBase {
  const MeiliRankingScoreDetailsExactnessRule._({
    required super.src,
    required super.order,
    required super.score,
    required this.matchType,
  });

  /// One of `exactMatch`, `matchesStart` or `noExactMatch`.
  /// - `exactMatch`: the document contains an attribute that exactly matches the query.
  /// - `matchesStart`: the document contains an attribute that exactly starts with the query.
  /// - `noExactMatch`: any other document.
  final String matchType;

  factory MeiliRankingScoreDetailsExactnessRule.fromJson(
    Map<String, dynamic> src,
  ) =>
      MeiliRankingScoreDetailsExactnessRule._(
        src: src,
        order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
        score: MeiliRankingScoreDetailsRuleBase._readScore(src),
        matchType: src['matchType'] as String,
      );
}
