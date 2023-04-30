import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Indexes', () {
    late String uid;
    setUpClient();
    setUp(() {
      uid = randomUid();
    });

    test('Create index with right UID without any primary passed', () async {
      await client.createIndex(uid).waitFor(client: client);

      final index = await client.getIndex(uid);

      expect(index.uid, uid);
      expect(index.primaryKey, null);
    });

    test('Create index with right UID with a primary', () async {
      await client.createIndex(uid, primaryKey: 'myId').waitFor(client: client);

      final index = await client.getIndex(uid);

      expect(index.uid, uid);
      expect(index.primaryKey, 'myId');
    });

    test('Update an index where the primary has not been set', () async {
      await client.createIndex(uid).waitFor(client: client);

      var index = await client.getIndex(uid);
      await index.update(primaryKey: 'nextId').waitFor(client: client);
      index = await client.getIndex(uid);

      expect(index.primaryKey, equals('nextId'));
    });

    test(
      'Update an index from the client where the primary has not been set',
      () async {
        await client.createIndex(uid).waitFor(client: client);

        await client.updateIndex(uid, 'nextId').waitFor(client: client);

        final index = await client.getIndex(uid);
        expect(index.primaryKey, equals('nextId'));
      },
    );

    test('Delete an existing index', () async {
      await client.createIndex(uid).waitFor(client: client);

      final index = await client.getIndex(uid);
      await index.delete().waitFor(client: client);

      await expectLater(
        client.getIndex(uid),
        throwsA(isA<MeiliSearchApiException>()),
      );
    });

    test('Delete index with right UID from the client', () async {
      await client.createIndex(uid).waitFor(client: client);
      await client.deleteIndex(uid).waitFor(client: client);

      await expectLater(
        client.getIndex(uid),
        throwsA(isA<MeiliSearchApiException>()),
      );
    });

    test('Get an existing index', () async {
      await client.createIndex(uid).waitFor(client: client);

      var index = await client.getIndex(uid);

      expect(index.uid, uid);
      expect(index.primaryKey, null);
    });

    test('gets raw information about an index', () async {
      await client.createIndex(uid).waitFor(client: client);

      final index = await client.getRawIndex(uid);
      final keys = ['uid', 'primaryKey', 'createdAt', 'updatedAt'];

      expect(index.keys, containsAll(keys));
      expect(index.keys.length, keys.length);
      expect(index['primaryKey'], isNull);
    });

    test('throws exception with a non-existing index', () async {
      expect(client.getIndex(randomUid('loremIpsum')),
          throwsA(isA<MeiliSearchApiException>()));
    });

    test('Get all indexes', () async {
      const count = 3;
      final ids = List.generate(count, (index) => randomUid());
      await Future.wait(ids.map(client.createIndex)).waitFor(client: client);

      final response = await client.getIndexes();

      expect(response.results.map((e) => e.uid), containsAll(ids));
    });

    test('Create index object with UID', () async {
      final index = client.index(uid, deleteWhenDone: false);

      expect(index.uid, uid);
      expect(index.primaryKey, null);
    });

    test('Create index object with UID and add Document', () async {
      var index = client.index(uid);
      await index.addDocuments([
        {'book_id': 123, 'title': 'Pride and Prejudice'}
      ]).waitFor(client: client);

      index = await client.getIndex(uid);

      expect(index.uid, uid);
    });

    test('Create index object and get it without add it', () async {
      client.index(uid, deleteWhenDone: false);

      await expectLater(
        client.getIndex(uid),
        throwsA(isA<MeiliSearchApiException>()),
      );
    });

    test('Geting index stats', () async {
      final index = client.index(uid);

      final response = await index.addDocuments([
        {'book_id': 123, 'title': 'Pride and Prejudice'},
        {'book_id': 456, 'title': 'The Martin'},
      ]).waitFor(client: client);

      expect(response.status, 'succeeded');
      final stats = await index.getStats();
      expect(stats.numberOfDocuments, 2);
    });

    test('gets all tasks by index', () async {
      await client.createIndex(uid).waitFor(client: client);
      final index = await client.getIndex(uid);

      await index.addDocuments([
        {'book_id': 1234, 'title': 'Pride and Prejudice'}
      ]);
      await index.addDocuments([
        {'book_id': 5678}
      ]);

      final tasks = await index.getTasks();

      expect(tasks.results.length, equals(3));
    });

    test('gets a task from a index by taskId', () async {
      final index = client.index(uid);
      final response = await index.addDocuments([
        {'book_id': 1234, 'title': 'Pride and Prejudice'}
      ]);

      final task = await index.getTask(response.uid!);

      expect(task.uid, response.uid!);
    });

    test('gets a task with a failure', () async {
      final index = client.index(uid);

      await expectLater(
        index.updateRankingRules(['invalid-rule']),
        throwsA(isA<MeiliSearchApiException>()),
      );
    });

    test('Getting non-existant update status', () async {
      await client.createIndex(uid).waitFor(client: client);

      final index = await client.getIndex(uid);
      await expectLater(
        index.getTask(-1),
        throwsA(isA<MeiliSearchApiException>()),
      );
    });

    test('extracts all possible properties from task', () async {
      final task = await client.createIndex(uid);

      expect(task.uid, greaterThan(0));
      expect(task.indexUid, equals(uid));
      expect(task.type, equals("indexCreation"));
    });
  });
}
