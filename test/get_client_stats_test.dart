import 'package:meilisearch/src/task.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Stats', () {
    setUpClient();

    test('Getting all stats', () async {
      final uid1 = randomUid();
      var index = client.index(uid1);
      var response = await index.addDocuments([
        {'book_id': 123, 'title': 'Pride and Prejudice'},
        {'book_id': 456, 'title': 'The Martin'},
      ]).waitFor();
      expect(response.status, 'succeeded');
      final uid2 = randomUid();
      index = client.index(uid2);
      response = await index.addDocuments([
        {'book_id': 789, 'title': 'Project Hail Mary'},
      ]).waitFor();
      expect(response.status, 'succeeded');
      final stats = await client.getStats();
      expect(stats.indexes!.length, 2);
      expect(stats.indexes!.keys, containsAll([uid1, uid2]));
    });

    test('gets all tasks', () async {
      final uid = randomUid();
      await client.createIndex(uid);

      final tasks = await client.getTasks();

      expect(tasks.length, greaterThan(0));
    });

    test('gets a task by taskId', () async {
      final uid = randomUid();
      final info = await client.createIndex(uid);

      final task = await client.getTask(info.uid);

      expect(task, isA<Task>());
      expect(task.uid, equals(info.uid));
    });
  });
}
