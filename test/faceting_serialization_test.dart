import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

void main() {
  group('Faceting serialization', () {
    test('serializes all supported facet sort types', () {
      const faceting = Faceting(
        maxValuesPerFacet: 20,
        sortFacetValuesBy: {
          '*': FacetingSortTypes.sampledCount,
          'genres': FacetingSortTypes.count,
          'author': FacetingSortTypes.alpha,
        },
      );

      expect(faceting.toMap(), {
        'maxValuesPerFacet': 20,
        'sortFacetValuesBy': {
          '*': 'sampledCount',
          'genres': 'count',
          'author': 'alpha',
        },
      });
    });

    test('deserializes sampledCount for an individual facet', () {
      final faceting = Faceting.fromMap({
        'sortFacetValuesBy': {'*': 'alpha', 'genres': 'sampledCount'},
      });

      expect(faceting.sortFacetValuesBy, {
        '*': FacetingSortTypes.alpha,
        'genres': FacetingSortTypes.sampledCount,
      });
    });

    test('round trips sampledCount as the wildcard fallback', () {
      final values = {
        'maxValuesPerFacet': 200,
        'sortFacetValuesBy': {'*': 'sampledCount', 'genres': 'alpha'},
      };

      expect(Faceting.fromMap(values).toMap(), values);
    });
  });
}
