import 'package:meilisearch/meilisearch.dart';
import 'package:collection/collection.dart';

Duration _nextInterval(Duration base, int attempt) {
  final baseMs = base.inMilliseconds <= 0 ? 1 : base.inMilliseconds;
  final multiplier = 1 << attempt.clamp(0, 3);
  final boundedMs = (baseMs * multiplier).clamp(baseMs, 500);
  return Duration(milliseconds: boundedMs);
}

String _taskDiagnostics(Task? task) {
  if (task == null) {
    return 'status=unknown, type=unknown, indexUid=unknown';
  }

  return 'status=${task.status ?? 'unknown'}, '
      'type=${task.type ?? 'unknown'}, '
      'indexUid=${task.indexUid ?? 'unknown'}';
}

extension TaskWaiter on Task {
  Future<Task> waitFor({
    required MeiliSearchClient client,
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 50),
    bool throwFailed = true,
  }) async {
    var endingTime = DateTime.now().add(timeout);
    var attempt = 0;
    Task? lastSeenTask;

    while (DateTime.now().isBefore(endingTime)) {
      final task = await client.getTask(uid!);
      lastSeenTask = task;

      if (task.status != 'enqueued' && task.status != 'processing') {
        if (throwFailed && task.status != 'succeeded') {
          throw MeiliSearchApiException(
            "Task ($uid) failed, error: ${task.error}",
            code: task.error?.code,
            link: task.error?.link,
            type: task.error?.type,
          );
        }
        return task;
      }

      await Future<void>.delayed(_nextInterval(interval, attempt));
      attempt++;
    }

    throw Exception(
      'Task wait timed out for task uid=$uid after ${timeout.inMilliseconds}ms '
      '(${_taskDiagnostics(lastSeenTask)}).',
    );
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
    final remainingUids = map((e) => e.uid).nonNulls.toList();
    final completedTasks = <int, Task>{};
    final lastSeenByUid = <int, Task>{};
    final statuses = ['enqueued', 'processing'];
    var attempt = 0;

    while (DateTime.now().isBefore(endingTime)) {
      final taskRes =
          await client.getTasks(params: TasksQuery(uids: remainingUids));
      final tasks = taskRes.results;
      for (final task in tasks) {
        final uid = task.uid;
        if (uid != null) {
          lastSeenByUid[uid] = task;
        }
      }
      final completed = tasks.where((e) => !statuses.contains(e.status));
      if (throwFailed) {
        final failed = completed
            .firstWhereOrNull((element) => element.status != 'succeeded');
        if (failed != null) {
          throw MeiliSearchApiException(
            "Task (${failed.uid}) failed, error: ${failed.error}",
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
        return originalUids.map((e) => completedTasks[e.uid]).nonNulls.toList();
      }
      await Future<void>.delayed(_nextInterval(interval, attempt));
      attempt++;
    }

    final statusByRemainingUid = remainingUids.map((uid) {
      final task = lastSeenByUid[uid];
      final status = task?.status ?? 'unknown';
      return '$uid: status=$status';
    }).join(', ');

    throw Exception(
      'Tasks wait timed out after ${timeout.inMilliseconds}ms. '
      'remaining uids=$remainingUids; last-seen status={$statusByRemainingUid}.',
    );
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
