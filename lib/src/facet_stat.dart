///When using the facets parameter, the distributed facets that contain some numeric values are displayed in a facetStats object that contains, per facet, the numeric min and max values of the hits returned by the search query.
///If none of the hits returned by the search query have a numeric value for a facet, this facet is not part of the facetStats object.
class FacetStat {
  ///The minimum value for the numerical facet being distributed.
  final num min;

  ///The maximum value for the numerical facet being distributed.
  final num max;

  const FacetStat({
    required this.min,
    required this.max,
  });

  factory FacetStat.fromMap(Map<String, Object?> src) {
    return FacetStat(
      min: src['min'] as num,
      max: src['max'] as num,
    );
  }
}
