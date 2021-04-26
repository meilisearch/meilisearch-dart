import 'package:test/test.dart';

import 'utils/client.dart';
import 'package:meilisearch/src/exception.dart';

void main() {
  group('Indexes', () {
    setUpClient();

    test('Create index with right UID without any primary passed', () async {
      final uid = randomUid();
      await client.createIndex(uid);
      final index = await client.getIndex(uid);
      expect(index.uid, uid);
      expect(index.primaryKey, null);
    });

    test('Create index with right UID with a primary', () async {
      final uid = randomUid();
      await client.createIndex(uid, primaryKey: 'myId');
      final index = await client.getIndex(uid);
      expect(index.uid, uid);
      expect(index.primaryKey, 'myId');
    });

    test('Update an index where the primary has not been set', () async {
      var index = await client.createIndex(randomUid());
      await index.update(primaryKey: 'nextId');
      expect(index.primaryKey, equals('nextId'));
    });

    test('Delete an existing index', () async {
      final uid = randomUid();
      var index = await client.createIndex(uid);
      await index.delete();
      expect(client.getIndex(uid), throwsA(isA<MeiliSearchApiException>()));
    });

    test('Get an existing index', () async {
      final uid = randomUid();
      await client.createIndex(uid);
      var index = await client.getIndex(uid);
      expect(index.uid, uid);
      expect(index.primaryKey, null);
    });

    test('Get a non-existing index', () async {
      expect(client.getIndex(randomUid('loremIpsum')),
          throwsA(isA<MeiliSearchApiException>()));
    });

    test('Get all indexes', () async {
      await client.createIndex(randomUid());
      await client.createIndex(randomUid());
      await client.createIndex(randomUid());
      var indexes = await client.getIndexes();
      expect(indexes.length, 3);
    });
  });
}
