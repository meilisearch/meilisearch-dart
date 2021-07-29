import 'package:meilisearch/src/exception.dart';
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

    test('able to get dump status', () async {
      final dump = await client.createDump();
      final dumpStatus = await client.getDumpStatus(dump['uid']!);
      expect(dumpStatus.keys, contains('uid'));
      expect(dumpStatus.keys, contains('status'));
      expect(dumpStatus['uid'], isNotEmpty);
      expect(dumpStatus['status'], isNotEmpty);
    });

    test('does not exist error', () async {
      expect(client.getDumpStatus('bad_uid'),
          throwsA(isA<MeiliSearchApiException>()));
    });
  });
}
