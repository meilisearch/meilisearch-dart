import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/books_data.dart';
import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group("Tasks", () {
    late String uid;
    late MeiliSearchIndex index;

    setUpClient();
    setUp(() {
      uid = randomUid();
      index = client.index(uid);
    });

    test('Query by type', () async {
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
        expect(queryRes.total, isPositive);
      }
    });
    test('cancels given an input', () async {
      final date = DateTime.now();
      final response = await client
          .cancelTasks(
            params: CancelTasksQuery(uids: [1, 2], beforeStartedAt: date),
          )
          .waitFor(client: client);

      expect(
        response.details!['originalFilter'],
        '?beforeStartedAt=${Uri.encodeComponent(date.toUtc().toIso8601String())}&uids=1%2C2',
      );
    });

    test('deletes given an input', () async {
      final date = DateTime.now();
      final response = await client
          .deleteTasks(
            params: DeleteTasksQuery(uids: [1, 2], beforeStartedAt: date),
          )
          .waitFor(client: client);

      expect(
        response.details!['originalFilter'],
        '?beforeStartedAt=${Uri.encodeComponent(date.toUtc().toIso8601String())}&uids=1%2C2',
      );
    });
  });

  test(
    'code samples',
    () async {
      // #docregion async_guide_filter_by_date_1
      await client.getTasks(
        params: TasksQuery(
          afterEnqueuedAt: DateTime(2020, 10, 11, 11, 49, 53),
        ),
      );
      // #enddocregion
      // #docregion async_guide_multiple_filters_1
      await client.getTasks(
        params: TasksQuery(
          indexUids: ['movies'],
          types: ['documentAdditionOrUpdate', 'documentDeletion'],
          statuses: ['processing'],
        ),
      );
      // #enddocregion
      // #docregion async_guide_filter_by_ids_1
      await client.getTasks(
        params: TasksQuery(
          uids: [5, 10, 13],
        ),
      );
      // #enddocregion
      // #docregion async_guide_filter_by_statuses_1
      await client.getTasks(
        params: TasksQuery(
          statuses: ['failed', 'canceled'],
        ),
      );
      // #enddocregion
      // #docregion async_guide_filter_by_types_1
      await client.getTasks(
        params: TasksQuery(
          types: ['dumpCreation', 'indexSwap'],
        ),
      );
      // #enddocregion
      // #docregion async_guide_filter_by_index_uids_1
      await client.getTasks(params: TasksQuery(indexUids: ['movies']));
      // #enddocregion
      // #docregion delete_tasks_1
      await client.deleteTasks(params: DeleteTasksQuery(uids: [1, 2]));
      // #enddocregion
      // #docregion cancel_tasks_1
      await client.cancelTasks(params: CancelTasksQuery(uids: [1, 2]));
      // #enddocregion
      // #docregion async_guide_canceled_by_1
      await client.getTasks(params: TasksQuery(canceledBy: [9, 15]));
      // #enddocregion
    },
    skip: true,
  );
}
