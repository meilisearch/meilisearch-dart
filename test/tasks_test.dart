import 'package:meilisearch/src/query_parameters/cancel_tasks_query.dart';
import 'package:meilisearch/src/query_parameters/delete_tasks_query.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Cancel Tasks', () {
    setUpClient();

    test('cancels tasks given an input', () async {
      var date = DateTime.now();
      var response = await client
          .cancelTasks(
              params: CancelTasksQuery(uids: [1, 2], beforeStartedAt: date))
          .waitFor(client: client);

      expect(response.status, 'succeeded');
      expect(response.details!['originalFilter'],
          '?beforeStartedAt=${Uri.encodeComponent(date.toUtc().toIso8601String())}&uids=1%2C2');
    });
  });

  group('Delete Tasks', () {
    setUpClient();

    test('delete tasks given an input', () async {
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
