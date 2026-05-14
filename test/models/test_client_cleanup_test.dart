import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'test_client.dart';

class _CleanupSpyClient extends TestMeiliSearchClient {
  _CleanupSpyClient() : super('http://localhost:7700');

  int getTaskCallCount = 0;
  final Map<int, int> _pollsByTaskUid = <int, int>{};

  @override
  Future<Task> deleteIndex(String uid) async {
    usedIndexes.remove(uid);

    return Task(
      uid: uid.hashCode & 0x7fffffff,
      indexUid: uid,
      status: 'enqueued',
      type: 'indexDeletion',
    );
  }

  @override
  Future<Task> getTask(int uid) async {
    getTaskCallCount++;
    final pollCount = (_pollsByTaskUid[uid] ?? 0) + 1;
    _pollsByTaskUid[uid] = pollCount;

    return Task(
      uid: uid,
      status: pollCount >= 2 ? 'succeeded' : 'enqueued',
      type: 'indexDeletion',
    );
  }
}

void main() {
  group('TestMeiliSearchClient resource cleanup', () {
    test('disposeUsedResources polls index deletion tasks until completion',
        () async {
      final client = _CleanupSpyClient();
      client.usedIndexes.addAll({'movies', 'books'});

      await client.disposeUsedResources();

      expect(
        client.getTaskCallCount,
        greaterThan(0),
        reason:
            'disposeUsedResources() should wait for async delete tasks to complete.',
      );
    });
  });
}
