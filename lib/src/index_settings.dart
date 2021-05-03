class IndexSettings {
  IndexSettings({
    this.synonyms,
    this.stopWords,
    this.rankingRules,
    this.attributesForFaceting,
    this.distinctAttribute,
    this.searchableAttributes = allAttributes,
    this.displayedAttributes = allAttributes,
  });

  static const allAttributes = <String>['*'];

  /// List of associated words treated similarly
  Map<String, List<String>>? synonyms;

  /// List of words ignored by MeiliSearch when present in search queries
  List<String>? stopWords;

  /// List of ranking rules sorted by order of importance
  List<String>? rankingRules;

  /// Attributes to use as [facets](https://docs.meilisearch.com/reference/features/faceted_search.html)
  List<String>? attributesForFaceting;

  /// Search returns documents with distinct (different) values of the given field
  List<String>? distinctAttribute;

  /// Fields in which to search for matching query words sorted by order of importance
  List<String>? searchableAttributes;

  /// Fields displayed in the returned documents
  List<String>? displayedAttributes;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'synonyms': synonyms,
        'stopWords': stopWords,
        'rankingRules': rankingRules,
        'attributesForFaceting': attributesForFaceting,
        'distinctAttribute': distinctAttribute,
        'searchableAttributes': searchableAttributes,
        'displayedAttributes': displayedAttributes,
      };

  factory IndexSettings.fromMap(Map<String, dynamic> map) => IndexSettings(
        synonyms: (map['synonyms'] as Map?)
            ?.cast<String, List>()
            .map((key, value) => MapEntry(key, value.cast<String>())),
        stopWords: (map['stopWords'] as List?)?.cast<String>(),
        rankingRules: (map['rankingRules'] as List?)?.cast<String>(),
        attributesForFaceting:
            (map['attributesForFaceting'] as List?)?.cast<String>(),
        distinctAttribute: (map['distinctAttribute'] as List?)?.cast<String>(),
        searchableAttributes:
            (map['searchableAttributes'] as List?)?.cast<String>(),
        displayedAttributes:
            (map['displayedAttributes'] as List?)?.cast<String>(),
      );
}
