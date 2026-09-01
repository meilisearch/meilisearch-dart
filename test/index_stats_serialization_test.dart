import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

void main() {
  group('IndexStats.fromMap', () {
    test('parses indexSize and usedIndexSize when present', () {
      final stats = IndexStats.fromMap({
        'numberOfDocuments': 2,
        'isIndexing': false,
        'fieldsDistribution': {'title': 2},
        'indexSize': 16384,
        'usedIndexSize': 8192,
      });

      expect(stats.numberOfDocuments, 2);
      expect(stats.isIndexing, isFalse);
      expect(stats.fieldsDistribution, {'title': 2});
      expect(stats.indexSize, 16384);
      expect(stats.usedIndexSize, 8192);
    });

    test('leaves size fields null on pre-1.53 responses', () {
      final stats = IndexStats.fromMap({
        'numberOfDocuments': 0,
        'isIndexing': false,
        'fieldsDistribution': <String, int>{},
      });

      expect(stats.indexSize, isNull);
      expect(stats.usedIndexSize, isNull);
    });
  });
}
