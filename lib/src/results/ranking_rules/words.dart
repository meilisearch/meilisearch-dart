part of 'base.dart';

class MeiliRankingScoreDetailsWordsRule
    extends MeiliRankingScoreDetailsRuleBase {
  const MeiliRankingScoreDetailsWordsRule._({
    required super.src,
    required super.order,
    required super.score,
    required this.matchingWords,
    required this.maxMatchingWords,
  });

  /// the number of words from the query found
  final int matchingWords;

  ///
  final int maxMatchingWords;

  factory MeiliRankingScoreDetailsWordsRule.fromJson(Map<String, dynamic> src) {
    return MeiliRankingScoreDetailsWordsRule._(
      src: src,
      order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
      score: MeiliRankingScoreDetailsRuleBase._readScore(src),
      matchingWords: src['matchingWords'] as int,
      maxMatchingWords: src['maxMatchingWords'] as int,
    );
  }
}
