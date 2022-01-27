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

  Map<String, dynamic> toMap() => <String, dynamic>{
        'synonyms': synonyms,
        'stopWords': stopWords,
        'rankingRules': rankingRules,
        'filterableAttributes': filterableAttributes,
        'distinctAttribute': distinctAttribute,
        'searchableAttributes': searchableAttributes,
        'displayedAttributes': displayedAttributes,
        'sortableAttributes': sortableAttributes,
      };

  factory IndexSettings.fromMap(Map<String, dynamic> map) => IndexSettings(
        synonyms: (map['synonyms'] as Map?)
            ?.cast<String, List>()
            .map((key, value) => MapEntry(key, value.cast<String>())),
        stopWords: (map['stopWords'] as List?)?.cast<String>(),
        rankingRules: (map['rankingRules'] as List?)?.cast<String>(),
        filterableAttributes:
            (map['filterableAttributes'] as List?)?.cast<String>(),
        distinctAttribute: (map['distinctAttribute'] as String?),
        searchableAttributes:
            (map['searchableAttributes'] as List?)?.cast<String>(),
        displayedAttributes:
            (map['displayedAttributes'] as List?)?.cast<String>(),
        sortableAttributes:
            (map['sortableAttributes'] as List?)?.cast<String>(),
      );
}
