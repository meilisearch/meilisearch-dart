import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/books_data.dart';
import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group("Tasks", () {
    setUpClient();
    test('Query by type', () async {
      final index = client.index(randomUid());
      final docs = books;
      final task = await index.addDocuments(docs);

      expect(task.type, 'documentAdditionOrUpdate');
      //test several permutations of indexUids
      final uidsToTest = [
        ["some_random_index"],
        [index.uid, "some_random_index"],
        const <String>[],
      ];
      for (final indexUids in uidsToTest) {
        final queryRes = await index.getTasks(
          params: TasksQuery(
            indexUids: indexUids,
            types: ['documentAdditionOrUpdate'],
          ),
        );
        expect(queryRes.results.first.uid, task.uid);
      }
    });
    test('cancels given an input', () async {
      var date = DateTime.now();
      var response = await client
          .cancelTasks(
              params: CancelTasksQuery(uids: [1, 2], beforeStartedAt: date))
          .waitFor(client: client);

      expect(response.status, 'succeeded');
      expect(response.details!['originalFilter'],
          '?beforeStartedAt=${Uri.encodeComponent(date.toUtc().toIso8601String())}&uids=1%2C2');
    });

    test('deletes given an input', () async {
      var date = DateTime.now();
      var response = await client
          .deleteTasks(
              params: DeleteTasksQuery(uids: [1, 2], beforeStartedAt: date))
          .waitFor(client: client);

      expect(response.status, 'succeeded');
      expect(response.details!['originalFilter'],
          '?beforeStartedAt=${Uri.encodeComponent(date.toUtc().toIso8601String())}&uids=1%2C2');
    });
  });
}
