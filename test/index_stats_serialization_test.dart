import 'package:meilisearch/src/results/all_stats.dart';
import 'package:meilisearch/src/results/index_stats.dart';
import 'package:test/test.dart';

void main() {
  group('IndexStats serialization', () {
    test('reads indexSize and usedIndexSize when the instance reports them',
        () {
      final stats = IndexStats.fromMap({
        'numberOfDocuments': 2,
        'isIndexing': false,
        'fieldsDistribution': {'objectID': 2},
        'indexSize': 98304,
        'usedIndexSize': 81920,
      });

      expect(stats.indexSize, 98304);
      expect(stats.usedIndexSize, 81920);
    });

    test('leaves both null when the instance does not report them', () {
      // Meilisearch instances older than v1.53.0 omit both fields.
      final stats = IndexStats.fromMap({
        'numberOfDocuments': 2,
        'isIndexing': false,
        'fieldsDistribution': {'objectID': 2},
      });

      expect(stats.indexSize, isNull);
      expect(stats.usedIndexSize, isNull);
      expect(stats.numberOfDocuments, 2);
    });

    test('keeps a reported zero distinct from an omitted field', () {
      final stats = IndexStats.fromMap({
        'numberOfDocuments': 0,
        'isIndexing': false,
        'indexSize': 0,
        'usedIndexSize': 0,
      });

      expect(stats.indexSize, 0);
      expect(stats.usedIndexSize, 0);
    });

    test('reads both fields from the all-indexes stats payload', () {
      final stats = AllStats.fromMap({
        'databaseSize': 1146880,
        'lastUpdate': '2025-11-15T10:03:15.000000000Z',
        'indexes': {
          'movies': {
            'numberOfDocuments': 2,
            'isIndexing': false,
            'fieldsDistribution': {'objectID': 2},
            'indexSize': 98304,
            'usedIndexSize': 81920,
          },
        },
      });

      expect(stats.indexes?['movies']?.indexSize, 98304);
      expect(stats.indexes?['movies']?.usedIndexSize, 81920);
    });
  });
}
