import 'package:meilisearch/src/query_parameters/_exports.dart';
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
  });
}
