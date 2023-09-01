part of 'base.dart';

class MeiliRankingScoreDetailsTypoRule
    extends MeiliRankingScoreDetailsRuleBase {
  const MeiliRankingScoreDetailsTypoRule._({
    required super.src,
    required super.order,
    required super.score,
    required this.typoCount,
    required this.maxTypoCount,
  });

  /// The number of typos to correct in the query to match that document.
  final int typoCount;

  /// The maximum number of typos that can be corrected in the query to match a document.
  final int maxTypoCount;

  factory MeiliRankingScoreDetailsTypoRule.fromJson(Map<String, dynamic> src) {
    return MeiliRankingScoreDetailsTypoRule._(
      src: src,
      order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
      score: MeiliRankingScoreDetailsRuleBase._readScore(src),
      typoCount: src['typoCount'] as int,
      maxTypoCount: src['maxTypoCount'] as int,
    );
  }
}
