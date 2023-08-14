import '../annotations.dart';
import 'facet_hit.dart';

@RequiredMeiliServerVersion('1.3.0')
class FacetSearchResult {
  final List<FacetHit> facetHits;
  final String facetQuery;
  final int processingTimeMs;

  const FacetSearchResult({
    required this.facetHits,
    required this.facetQuery,
    required this.processingTimeMs,
  });

  factory FacetSearchResult.fromMap(Map<String, dynamic> map) {
    return FacetSearchResult(
      facetHits: List<FacetHit>.from(
        (map['facetHits'] as List?)
                ?.cast<Map<String, dynamic>>()
                .map(FacetHit.fromMap)
                .toList() ??
            [],
      ),
      facetQuery: map['facetQuery'] as String,
      processingTimeMs: map['processingTimeMs'] as int,
    );
  }
}
