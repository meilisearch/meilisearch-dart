import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Indexes', () {
    setUpClient();

    test('Create index with right UID without any primary passed', () async {
      await client.createIndex(randomUid());
    });

    test('Create index with right UID with a primary', () async {
      await client.createIndex(randomUid(), primaryKey: 'myId');
    });

    test('Update an index where the primary has not been set', () async {
      var index = await client.createIndex(randomUid());
      await index.update(primaryKey: 'nextId');
      expect(index.primaryKey, equals('nextId'));
    });

    test('Delete an existing index', () async {
      var index = await client.createIndex(randomUid());
      await index.delete();
    });

    test('Get an existing index', () async {
      var uid = randomUid();
      await client.createIndex(uid);
      var index = await client.getIndex(uid);
      expect(index, isNotNull);
    });

    test('Get a non-existing index', () async {
      expect(client.getIndex(randomUid('loremIpsum')), throwsException);
    });

    test('Get all indexes', () async {
      await client.createIndex(randomUid());
      await client.createIndex(randomUid());
      await client.createIndex(randomUid());
      var indexes = await client.getIndexes();
      expect(indexes, isNotEmpty);
    });
  });
}
