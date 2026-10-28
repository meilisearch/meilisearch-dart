import 'package:meilisearch/src/annotations.dart';

enum FacetingSortTypes {
  alpha('alpha'),
  count('count'),

  /// Sorts facet values by an estimated count computed from a sample of the
  /// documents, instead of counting every matching document.
  ///
  /// Requires Meilisearch v1.56.0 or later.
  sampledCount('sampledCount');

  final String value;

  const FacetingSortTypes(this.value);
}

class Faceting {
  /// Define maximum number of value returned for a facet for a **search query**.
  /// It means that with the default value of `100`,
  /// it is not possible to have `101` different colors if the `color`` field is defined as a facet at search time.
  final int? maxValuesPerFacet;

  /// Defines how facet values are sorted.
  ///
  /// By default, all facets (`*`) are sorted by name, alphanumerically in ascending order (`alpha`).
  ///
  /// `count` sorts facet values by the number of documents containing a facet value in descending order.
  ///
  /// `sampledCount` sorts facet values by an estimated count computed from a
  /// sample of the documents. Requires Meilisearch v1.56.0 or later.
  ///
  /// example:
  ///   "*": 'alpha
  ///   "genres": count
  ///   "tags": sampledCount
  @RequiredMeiliServerVersion('1.3.0')
  final Map<String, FacetingSortTypes>? sortFacetValuesBy;

  const Faceting({
    this.maxValuesPerFacet,
    this.sortFacetValuesBy,
  });

  Map<String, dynamic> toMap() {
    return {
      if (maxValuesPerFacet != null) 'maxValuesPerFacet': maxValuesPerFacet,
      if (sortFacetValuesBy != null)
        'sortFacetValuesBy':
            sortFacetValuesBy?.map((key, value) => MapEntry(key, value.value)),
    };
  }

  factory Faceting.fromMap(Map<String, dynamic> map) {
    return Faceting(
      maxValuesPerFacet: map['maxValuesPerFacet'] as int?,
      sortFacetValuesBy:
          (map['sortFacetValuesBy'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          FacetingSortTypes.values
              .firstWhere((element) => element.value == value),
        ),
      ),
    );
  }
}
