import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Dump', () {
    setUpClient();

    test('creates a dump', () async {
      final task = await client.createDump();

      expect(task.type, equals('dumpCreation'));
      expect(task.status, anyOf('succeeded', 'enqueued'));
      expect(task.indexUid, isNull);
    });
  });
}
