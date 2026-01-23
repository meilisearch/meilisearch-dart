import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';
import 'utils/client.dart';

void main() {
  group("Export", () {
    setUpClient();

    test("Export data to random URL", () async {
      final result = await client.export(ExportQuery(
        url: 'https://example.com',
      ));
      expect(result.uid, greaterThan(0));
      expect(result.indexUid, isNull);
      expect(result.status, equals("enqueued"));
      expect(result.type, equals("export"));
    });

    test('ExportIndexOptions serializes correctly with filterExpression', () {
      final options = ExportIndexOptions(
          filterExpression: Meili.gt(
            Meili.attr('test_attr'),
            10.toMeiliValue(),
          ),
          overrideSettings: true);

      final map = options.asMap();

      expect(map['filter'], '"test_attr" > 10');
      expect(map['overrideSettings'], true);
      expect(options.containsFilter, true);
    });

    test('ExportQuery serializes correctly', () {
      final options = ExportIndexOptions(
          filterExpression: Meili.gt(
            Meili.attr('test_attr'),
            10.toMeiliValue(),
          ),
          overrideSettings: true);
      final query = ExportQuery(
          url: 'test_url',
          apiKey: "test_key",
          payloadSize: "100 MiB",
          indexes: {'test_index': options});

      final map = query.buildMap();

      expect(map['url'], 'test_url');
      expect(map['apiKey'], "test_key");
      expect(map['payloadSize'], "100 MiB");
      expect(map['indexes'], {'test_index': options.asMap()});
    });
  });
}
