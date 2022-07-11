import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Dump', () {
    setUpClient();

    test('creates a dump', () async {
      final dump = await client.createDump();

      expect(dump.type, equals('dumpCreation'));
      expect(dump.status, anyOf('succeeded', 'enqueued'));
    });
  });
}
