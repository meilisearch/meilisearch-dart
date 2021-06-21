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

    test('Update an index from the client where the primary has not been set',
        () async {
      final uid = randomUid();
      await client.createIndex(uid);
      await client.updateIndex(uid, 'nextId');
      final index = await client.getIndex(uid);
      expect(index.primaryKey, equals('nextId'));
    });

    test('Delete an existing index', () async {
      final uid = randomUid();
      var index = await client.createIndex(uid);
      await index.delete();
      expect(client.getIndex(uid), throwsA(isA<MeiliSearchApiException>()));
    });

    test('Delete index with right UID from the client', () async {
      final uid = randomUid();
      await client.createIndex(uid);
      await client.deleteIndex(uid);
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

    test('GetOrCreate index with right UID', () async {
      final uid = randomUid();
      await client.getOrCreateIndex(uid);
      final index = await client.getIndex(uid);
      expect(index.uid, uid);
    });

    test('GetOrCreate index with right UID with a primary', () async {
      final uid = randomUid();
      await client.getOrCreateIndex(uid, primaryKey: 'myId');
      final index = await client.getIndex(uid);
      expect(index.uid, uid);
      expect(index.primaryKey, 'myId');
    });

    test('GetOrCreate index on existing index', () async {
      final uid = randomUid();
      await client.createIndex(uid);
      await client.getOrCreateIndex(uid);
      final index = await client.getIndex(uid);
      expect(index.uid, uid);
    });

    test('Create index object with UID', () async {
      final uid = randomUid();
      final index = client.index(uid);
      expect(index.uid, uid);
      expect(index.primaryKey, null);
    });

    test('Create index object with UID and add Document', () async {
      final uid = randomUid();
      var indexObject = client.index(uid);
      final response = await indexObject.addDocuments([
        {'book_id': 123, 'title': 'Pride and Prejudice'}
      ]).waitFor();
      expect(response.status, 'processed');
      final index = await client.getIndex(uid);
      expect(index.uid, uid);
    });

    test('Create index object and get it without add it', () async {
      final uid = randomUid();
      client.index(uid);
      expect(client.getIndex(randomUid(uid)),
          throwsA(isA<MeiliSearchApiException>()));
    });
  });
}
