import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Dump', () {
    setUpClient();

    test('is created', () async {
      final dump = await client.createDump();
      expect(dump.keys, contains('uid'));
      expect(dump.keys, contains('status'));
      expect(dump['uid'], isNotEmpty);
      expect(dump['status'], equals('in_progress'));
    });
  });
}
