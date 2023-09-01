part 'attribute.dart';
part 'exactness.dart';
part 'proximity.dart';
part 'typo.dart';
part 'words.dart';

abstract class MeiliRankingScoreDetailsRuleBase {
  /// The source json object this was created from.
  final Map<String, dynamic> src;

  /// The order that this ranking rule was applied
  final int order;

  /// The relevancy score of a document according to a ranking rule and relative to a search query.
  ///
  /// Higher is better.
  ///
  /// - `1.0` indicates a perfect match
  /// - `0.0` no match at all (Meilisearch should not return documents that don't match the query).
  final double score;

  const MeiliRankingScoreDetailsRuleBase({
    required this.src,
    required this.order,
    required this.score,
  });

  static int _readOrder(Map<String, dynamic> src) => src['order'] as int;
  static double _readScore(Map<String, dynamic> src) => src['score'] as double;
}

/// Custom rule in the form of either `attribute:direction` or `_geoPoint(lat, lng):direction`.
class MeiliRankingScoreDetailsCustomRule {
  /// The source json object this was created from.
  final Map<String, dynamic> src;

  /// The order that this ranking rule was applied
  final int order;

  /// The value that was used for sorting this document
  /// - string
  /// - number
  /// - point
  final dynamic value;

  /// The distance between the target point and the geoPoint in the document
  final num? distance;

  const MeiliRankingScoreDetailsCustomRule({
    required this.src,
    required this.order,
    required this.value,
    required this.distance,
  });

  factory MeiliRankingScoreDetailsCustomRule.fromJson(
          Map<String, dynamic> src) =>
      MeiliRankingScoreDetailsCustomRule(
        src: src,
        order: MeiliRankingScoreDetailsRuleBase._readOrder(src),
        distance: src['distance'] as num?,
        value: src['value'],
      );
}
