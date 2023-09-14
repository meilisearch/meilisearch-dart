import 'package:meilisearch/src/annotations.dart';

import 'match_position.dart';
import 'ranking_rules/base.dart';
import 'searchable.dart';

/// A class that wraps around documents returned from meilisearch to provide useful information.
final class MeiliDocumentContainer<T extends Object> {
  const MeiliDocumentContainer._({
    required this.rankingScoreDetails,
    required this.src,
    required this.parsed,
    required this.formatted,
    required this.vectors,
    required this.semanticScore,
    required this.rankingScore,
    required this.matchesPosition,
  });

  final Map<String, dynamic> src;
  final T parsed;
  final Map<String, dynamic>? formatted;
  @RequiredMeiliServerVersion('1.3.0')
  final List<dynamic /* double | List<double> */ >? vectors;
  @RequiredMeiliServerVersion('1.3.0')
  final double? semanticScore;
  @RequiredMeiliServerVersion('1.3.0')
  final double? rankingScore;
  @RequiredMeiliServerVersion('1.3.0')
  final MeiliRankingScoreDetails? rankingScoreDetails;

  /// Contains the location of each occurrence of queried terms across all fields
  final Map<String, List<MatchPosition>>? matchesPosition;

  dynamic operator [](String key) => src[key];
  dynamic getFormatted(String key) => formatted?[key];

  dynamic getFormattedOrSrc(String key) => getFormatted(key) ?? this[key];

  static MeiliDocumentContainer<Map<String, dynamic>> fromJson(
    Map<String, dynamic> src,
  ) {
    final rankingScoreDetails =
        src['_rankingScoreDetails'] as Map<String, dynamic>?;
    return MeiliDocumentContainer<Map<String, dynamic>>._(
      src: src,
      parsed: src,
      formatted: src['_formatted'] as Map<String, dynamic>?,
      vectors: src['_vectors'] as List?,
      semanticScore: src['_semanticScore'] as double?,
      rankingScore: src['_rankingScore'] as double?,
      matchesPosition: _readMatchesPosition(src),
      rankingScoreDetails: rankingScoreDetails == null
          ? null
          : MeiliRankingScoreDetails.fromJson(rankingScoreDetails),
    );
  }

  MeiliDocumentContainer<TOther> map<TOther extends Object>(
    MeilisearchDocumentMapper<T, TOther> mapper,
  ) {
    return MeiliDocumentContainer._(
        src: src,
        parsed: mapper(parsed),
        formatted: formatted,
        vectors: vectors,
        semanticScore: semanticScore,
        rankingScore: rankingScore,
        rankingScoreDetails: rankingScoreDetails,
        matchesPosition: matchesPosition);
  }

  @override
  String toString() => src.toString();
}

class MeiliRankingScoreDetails {
  const MeiliRankingScoreDetails._({
    required this.src,
    required this.words,
    required this.typo,
    required this.proximity,
    required this.attribute,
    required this.exactness,
    required this.customRules,
  });
  final Map<String, dynamic> src;
  final MeiliRankingScoreDetailsWordsRule? words;
  final MeiliRankingScoreDetailsTypoRule? typo;
  final MeiliRankingScoreDetailsProximityRule? proximity;
  final MeiliRankingScoreDetailsAttributeRule? attribute;
  final MeiliRankingScoreDetailsExactnessRule? exactness;
  final Map<String, MeiliRankingScoreDetailsCustomRule> customRules;

  factory MeiliRankingScoreDetails.fromJson(Map<String, dynamic> src) {
    final reservedKeys = {
      'attribute',
      'words',
      'exactness',
      'proximity',
      'typo',
    };

    T? ruleGuarded<T>(
      String key,
      T Function(Map<String, dynamic> src) mapper,
    ) {
      final v = src[key];
      if (v == null) {
        return null;
      }
      return mapper(v as Map<String, dynamic>);
    }

    return MeiliRankingScoreDetails._(
      src: src,
      attribute: ruleGuarded(
        'attribute',
        MeiliRankingScoreDetailsAttributeRule.fromJson,
      ),
      words: ruleGuarded(
        'words',
        MeiliRankingScoreDetailsWordsRule.fromJson,
      ),
      exactness: ruleGuarded(
        'exactness',
        MeiliRankingScoreDetailsExactnessRule.fromJson,
      ),
      proximity: ruleGuarded(
        'proximity',
        MeiliRankingScoreDetailsProximityRule.fromJson,
      ),
      typo: ruleGuarded(
        'typo',
        MeiliRankingScoreDetailsTypoRule.fromJson,
      ),
      customRules: {
        for (var custom in src.entries
            .where((element) => !reservedKeys.contains(element.key)))
          custom.key: MeiliRankingScoreDetailsCustomRule.fromJson(
            custom.value as Map<String, dynamic>,
          )
      },
    );
  }
}

Map<String, List<MatchPosition>>? _readMatchesPosition(
  Map<String, Object?> map,
) {
  final src = map['_matchesPosition'];

  if (src == null) return null;

  return (src as Map<String, Object?>).map(
    (key, value) => MapEntry(
      key,
      (value as List<Object?>)
          .map((e) => MatchPosition.fromMap(e as Map<String, Object?>))
          .toList(),
    ),
  );
}
