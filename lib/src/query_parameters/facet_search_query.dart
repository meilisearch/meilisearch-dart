import '../annotations.dart';
import 'search_query.dart';

@RequiredMeiliServerVersion('1.3.0')
class FacetSearchQuery extends SearchQuery {
  const FacetSearchQuery({
    required this.facetName,
    this.facetQuery = '',
    this.q = '',
    //Per spec, only filter and matchingStrategy are shared with the parent SearchQuery

    /// Additional search parameter.
    ///
    /// If additional search parameters are set, the method will return facet values that both:
    ///   - Match the face query
    ///   - Are contained in the records matching the additional search parameters
    super.filter,
    super.filterExpression,
    super.matchingStrategy,
  });

  final String facetName;

  final String facetQuery;

  /// Additional search parameter.
  ///
  /// If additional search parameters are set, the method will return facet values that both:
  ///   - Match the face query
  ///   - Are contained in the records matching the additional search parameters
  final String q;

  @override
  Map<String, Object?> buildMap() {
    return {
      'facetName': facetName,
      'facetQuery': facetQuery,
      'q': q,
      ...super.buildMap(),
    };
  }
}
