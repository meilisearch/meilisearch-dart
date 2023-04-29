import 'package:meilisearch/src/task.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Stats', () {
    setUpClient();

    test('Getting all stats', () async {
      //index 1
      final uid1 = randomUid();
      var index = client.index(uid1);
      addTearDown(() => client.deleteIndex(uid1));

      var response = await index.addDocuments([
        {'book_id': 123, 'title': 'Pride and Prejudice'},
        {'book_id': 456, 'title': 'The Martin'},
      ]).waitFor(client: client);

      expect(response.status, 'succeeded');

      //index 2
      final uid2 = randomUid();
      index = client.index(uid2);
      addTearDown(() => client.deleteIndex(uid2));

      response = await index.addDocuments([
        {'book_id': 789, 'title': 'Project Hail Mary'},
      ]).waitFor(client: client);

      expect(response.status, 'succeeded');

      //stats
      final stats = await client.getStats();
      /*since tests might run concurrently, this needs to only check specific index uids*/
      expect(stats.indexes!.keys, containsAll([uid1, uid2]));
    });

    test('gets all tasks', () async {
      final uid = randomUid();
      await client.createIndex(uid);
      addTearDown(() => client.deleteIndex(uid));

      final tasks = await client.getTasks();

      expect(tasks.results, hasLength(greaterThan(0)));
      expect(tasks.results.first, isA<Task>());
    });

    test('gets a task by taskId', () async {
      final uid = randomUid();
      final info = await client.createIndex(uid);
      addTearDown(() => client.deleteIndex(uid));

      final task = await client.getTask(info.uid!);

      expect(task, isA<Task>());
      expect(task.uid, equals(info.uid));
    });
  });
}
