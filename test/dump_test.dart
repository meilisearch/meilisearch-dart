import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Dump', () {
    setUpClient();
    test('creates a dump', () async {
      final task = await client.createDump();
      //this teardown is to ensure no dump actually happens, since we are only checking the returned task
      addTearDown(() async {
        await client
            .cancelTasks(params: CancelTasksQuery(uids: [task.uid!]))
            .waitFor(client: client);
        await task.waitFor(client: client, throwFailed: false);
      });

      expect(task.type, equals('dumpCreation'));
      expect(task.status, anyOf('succeeded', 'enqueued'));
      expect(task.indexUid, isNull);
    });
  });
}
