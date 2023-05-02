import 'package:meilisearch/meilisearch.dart';
import 'package:collection/collection.dart';

extension TaskWaiter on Task {
  Future<Task> waitFor({
    required MeiliSearchClient client,
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 50),
    bool throwFailed = true,
  }) async {
    var endingTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endingTime)) {
      final task = await client.getTask(uid!);

      if (task.status != 'enqueued' && task.status != 'processing') {
        if (throwFailed && task.status != 'succeeded') {
          throw MeiliSearchApiException(
            "Task ($uid) failed",
            code: task.error?.code,
            link: task.error?.link,
            type: task.error?.type,
          );
        }
        return task;
      }

      await Future<void>.delayed(interval);
    }

    throw Exception('The task $uid timed out.');
  }
}

extension TaskWaiterForLists on Iterable<Task> {
  Future<List<Task>> waitFor({
    required MeiliSearchClient client,
    Duration timeout = const Duration(seconds: 20),
    Duration interval = const Duration(milliseconds: 50),
    bool throwFailed = true,
  }) async {
    final endingTime = DateTime.now().add(timeout);
    final originalUids = toList();
    final remainingUids = map((e) => e.uid).whereNotNull().toList();
    final completedTasks = <int, Task>{};
    final statuses = ['enqueued', 'processing'];

    while (DateTime.now().isBefore(endingTime)) {
      final taskRes =
          await client.getTasks(params: TasksQuery(uids: remainingUids));
      final tasks = taskRes.results;
      final completed = tasks.where((e) => !statuses.contains(e.status));
      if (throwFailed) {
        final failed = completed
            .firstWhereOrNull((element) => element.status != 'succeeded');
        if (failed != null) {
          throw MeiliSearchApiException(
            "Task (${failed.uid}) failed",
            code: failed.error?.code,
            link: failed.error?.link,
            type: failed.error?.type,
          );
        }
      }

      completedTasks.addEntries(completed.map((e) => MapEntry(e.uid!, e)));
      remainingUids
          .removeWhere((element) => completedTasks.containsKey(element));

      if (remainingUids.isEmpty) {
        return originalUids
            .map((e) => completedTasks[e.uid])
            .whereNotNull()
            .toList();
      }
      await Future<void>.delayed(interval);
    }

    throw Exception('The tasks $originalUids timed out.');
  }
}

extension TaskWaiterForFutures on Future<Task> {
  Future<Task> waitFor({
    required MeiliSearchClient client,
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 50),
    bool throwFailed = true,
  }) async {
    return await (await this).waitFor(
      timeout: timeout,
      interval: interval,
      client: client,
      throwFailed: throwFailed,
    );
  }
}

extension TaskWaiterForFutureList on Future<Iterable<Task>> {
  Future<List<Task>> waitFor({
    required MeiliSearchClient client,
    Duration timeout = const Duration(seconds: 20),
    Duration interval = const Duration(milliseconds: 50),
    bool throwFailed = true,
  }) async {
    return await (await this).waitFor(
      timeout: timeout,
      interval: interval,
      client: client,
      throwFailed: throwFailed,
    );
  }
}
