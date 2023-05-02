import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Dump', () {
    setUpClient();
    test('creates a dump', () async {
      final task = await client.createDump();
      //this teardown is to ensure no dump actually happens, since we are only checking the returned task
      addTearDown(
        () => client.cancelTasks(params: CancelTasksQuery(uids: [task.uid!])),
      );

      expect(task.type, equals('dumpCreation'));
      expect(task.status, anyOf('succeeded', 'enqueued'));
      expect(task.indexUid, isNull);
    });
  });
}
