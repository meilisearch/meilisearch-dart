import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/wait_for.dart';

class _AlwaysEnqueuedTaskClient extends MeiliSearchClient {
  _AlwaysEnqueuedTaskClient() : super('http://localhost:7700');

  @override
  Future<Task> getTask(int uid) async {
    return Task(
      uid: uid,
      status: 'enqueued',
    );
  }

  @override
  Future<TasksResults> getTasks({TasksQuery? params}) async {
    return TasksResults(
      results: params?.uids
              .map(
                (uid) => Task(
                  uid: uid,
                  status: 'enqueued',
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class _TaskNotFoundClient extends MeiliSearchClient {
  _TaskNotFoundClient() : super('http://localhost:7700');

  @override
  Future<Task> getTask(int uid) async {
    throw MeiliSearchApiException(
      'Task `$uid` not found.',
      code: 'task_not_found',
      type: 'invalid_request',
      link: 'https://docs.meilisearch.com/errors#task_not_found',
    );
  }
}

void main() {
  group('Task.waitFor timeout diagnostics', () {
    final client = _AlwaysEnqueuedTaskClient();

    test('single task timeout includes status and task uid', () async {
      final task = Task(uid: 42, status: 'enqueued');

      await expectLater(
        () => task.waitFor(
          client: client,
          timeout: const Duration(milliseconds: 1),
          interval: const Duration(milliseconds: 1),
        ),
        throwsA(
          allOf(
            isA<Exception>(),
            predicate(
              (error) => error.toString().contains('status'),
              'contains status in timeout diagnostics',
            ),
            predicate(
              (error) => error.toString().contains('${task.uid}'),
              'contains task uid in timeout diagnostics',
            ),
          ),
        ),
      );
    });

    test('list timeout includes status and each task uid', () async {
      final tasks = [
        Task(uid: 1001, status: 'enqueued'),
        Task(uid: 1002, status: 'enqueued'),
      ];

      await expectLater(
        () => tasks.waitFor(
          client: client,
          timeout: const Duration(milliseconds: 1),
          interval: const Duration(milliseconds: 1),
        ),
        throwsA(
          allOf(
            isA<Exception>(),
            predicate(
              (error) => error.toString().contains('status'),
              'contains status in timeout diagnostics',
            ),
            predicate(
              (error) => error.toString().contains('${tasks.first.uid}'),
              'contains first task uid in timeout diagnostics',
            ),
            predicate(
              (error) => error.toString().contains('${tasks.last.uid}'),
              'contains second task uid in timeout diagnostics',
            ),
          ),
        ),
      );
    });
  });

  group('Task.waitFor task-not-found diagnostics', () {
    final client = _TaskNotFoundClient();

    test('single task surfaces a clearer concurrency hint', () async {
      final task = Task(uid: 42, status: 'enqueued');

      await expectLater(
        () => task.waitFor(
          client: client,
          timeout: const Duration(milliseconds: 1),
          interval: const Duration(milliseconds: 1),
        ),
        throwsA(
          allOf(
            isA<Exception>(),
            predicate(
              (error) => error
                  .toString()
                  .contains('tests may be deleting tasks concurrently'),
              'contains concurrency cleanup hint',
            ),
            predicate(
              (error) => error.toString().contains('${task.uid}'),
              'contains task uid',
            ),
          ),
        ),
      );
    });
  });
}
