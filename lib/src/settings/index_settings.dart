import 'typo_tolerance.dart';

class IndexSettings {
  IndexSettings({
    this.synonyms,
    this.stopWords,
    this.rankingRules,
    this.filterableAttributes,
    this.distinctAttribute,
    this.sortableAttributes,
    this.searchableAttributes = allAttributes,
    this.displayedAttributes = allAttributes,
    this.typoTolerance,
  });

  static const allAttributes = <String>['*'];

  /// List of associated words treated similarly
  Map<String, List<String>>? synonyms;

  /// List of words ignored by Meilisearch when present in search queries
  List<String>? stopWords;

  /// List of ranking rules sorted by order of importance
  List<String>? rankingRules;

  /// Attributes to use in [filters](https://docs.meilisearch.com/reference/features/filtering_and_faceted_search.html)
  List<String>? filterableAttributes;

  /// Search returns documents with distinct (different) values of the given field
  String? distinctAttribute;

  /// Fields in which to search for matching query words sorted by order of importance
  List<String>? searchableAttributes;

  /// Fields displayed in the returned documents
  List<String>? displayedAttributes;

  /// List of attributes by which to sort results
  List<String>? sortableAttributes;

  /// Customize typo tolerance feature.
  TypoTolerance? typoTolerance;

  Map<String, Object?> toMap() => <String, Object?>{
        'synonyms': synonyms,
        'stopWords': stopWords,
        'rankingRules': rankingRules,
        'filterableAttributes': filterableAttributes,
        'distinctAttribute': distinctAttribute,
        'searchableAttributes': searchableAttributes,
        'displayedAttributes': displayedAttributes,
        'sortableAttributes': sortableAttributes,
        'typoTolerance': typoTolerance?.toMap()
      };

  factory IndexSettings.fromMap(Map<String, Object?> map) {
    final typoTolerance = map['typoTolerance'];
    final synonyms = map['synonyms'];
    final stopWords = map['stopWords'];
    final rankingRules = map['rankingRules'];
    final filterableAttributes = map['filterableAttributes'];
    final searchableAttributes = map['searchableAttributes'];
    final displayedAttributes = map['displayedAttributes'];
    final sortableAttributes = map['sortableAttributes'];

    return IndexSettings(
      synonyms: synonyms is Map<String, Object?>
          ? synonyms
              .cast<String, List<Object?>>()
              .map((key, value) => MapEntry(key, value.cast<String>()))
          : null,
      stopWords:
          stopWords is List<Object?> ? stopWords.cast<String>().toList() : null,
      rankingRules:
          rankingRules is List<Object?> ? rankingRules.cast<String>() : null,
      filterableAttributes: filterableAttributes is List<Object?>
          ? filterableAttributes.cast<String>()
          : null,
      distinctAttribute: (map['distinctAttribute'] as String?),
      searchableAttributes: searchableAttributes is List<Object?>
          ? searchableAttributes.cast<String>()
          : allAttributes,
      displayedAttributes: displayedAttributes is List<Object?>
          ? displayedAttributes.cast<String>()
          : allAttributes,
      sortableAttributes: sortableAttributes is List<Object?>
          ? sortableAttributes.cast<String>()
          : null,
      typoTolerance: typoTolerance is Map<String, Object?>
          ? TypoTolerance.fromMap(typoTolerance)
          : null,
    );
  }
}
