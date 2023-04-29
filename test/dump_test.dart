import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Dump', () {
    setUpClient();
    test('creates a dump', () async {
      final task = await client.createDump();
      addTearDown(
        () => client.cancelTasks(params: CancelTasksQuery(uids: [task.uid!])),
      );

      expect(task.type, equals('dumpCreation'));
      expect(task.status, anyOf('succeeded', 'enqueued'));
      expect(task.indexUid, isNull);
    });
  });
}
