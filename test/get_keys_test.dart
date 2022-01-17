import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/exception.dart';
import 'package:meilisearch/src/key.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Keys', () {
    setUpClient();

    group('When has master key', () {
      test('responds with all keys', () async {
        await client.createKey(indexes: ['movies'], actions: ['*']);

        final allKeys = await client.getKeys();

        expect(allKeys, isA<List<Key>>());
        expect(allKeys.length, greaterThan(0));
      });

      test('gets a key from server by key/uid', () async {
        final _key = await client.createKey(indexes: ['*'], actions: ['*']);

        Key key = await client.getKey(_key.key);

        expect(key.description, equals(_key.description));
        expect(key.actions, equals(['*']));
        expect(key.indexes, equals(['*']));
        expect(key.key, _key.key);
        expect(key.expiresAt, isNull);
        expect(key.createdAt, _key.createdAt);
        expect(key.updatedAt, _key.updatedAt);
      });

      test('creates a new key', () async {
        Key key = await client.createKey(
            description: "awesome-key",
            actions: ["documents.add"],
            indexes: ["movies"]);

        expect(key.description, equals("awesome-key"));
        expect(key.actions, equals(["documents.add"]));
        expect(key.indexes, equals(["movies"]));
        expect(key.expiresAt, isNull);
      });

      test('creates a new key with expiresAt', () async {
        var dt = DateTime.now().add(const Duration(days: 50)).toUtc();

        Key key = await client.createKey(
            actions: ["documents.add"], indexes: ["movies"], expiresAt: dt);

        expect(key.description, isNull);
        // Meilisearch's API doesn't support microseconds/milliseconds
        // so we must crop them before send and remove it to assert properly.
        dt = dt.subtract(Duration(
            microseconds: dt.microsecond, milliseconds: dt.millisecond));
        expect(key.expiresAt, equals(dt));
        expect(key.expiresAt!.isAtSameMomentAs(dt), isTrue);
      });

      test('updates a key partially', () async {
        final key = await client.createKey(
            actions: ["*"], indexes: ["*"], expiresAt: DateTime(2114));

        final newKey = await client.updateKey(key.key, indexes: ['movies']);

        expect(newKey.indexes, equals(['movies']));
        expect(newKey.actions, equals(['*']));
        expect(newKey.expiresAt, isNotNull);
        expect(newKey.expiresAt, equals(key.expiresAt));
        expect(newKey.description, equals(key.description));
      });

      test('updates key expiresAt', () async {
        final key = await client.createKey(actions: ["*"], indexes: ["*"]);

        final newKey = await client.updateKey(key.key,
            expiresAt: DateTime.now().add(Duration(days: 1)));

        expect(key.expiresAt, isNull);
        expect(newKey.expiresAt, isNotNull);
      });

      test('deletes a key', () async {
        final key = await client.createKey(actions: ["*"], indexes: ["*"]);

        expect(await client.deleteKey(key.key), isTrue);
      });
    });

    group('When has a key with search scope only', () {
      setUp(() async {
        final key = await client.createKey(indexes: ['*'], actions: ['search']);
        await client.createIndex('movies').waitFor();

        client = MeiliSearchClient(testServer, key.key);
      });

      tearDown(() {
        client = MeiliSearchClient(testServer, 'masterKey');
      });

      test('throws MeiliSearchApiException in getKeys call', () async {
        expect(() async => await client.getKeys(),
            throwsA(isA<MeiliSearchApiException>()));
      });

      test('throws MeiliSearchApiException in createKey call', () async {
        expect(
            () async => await client.createKey(actions: ['*'], indexes: ['*']),
            throwsA(isA<MeiliSearchApiException>()));
      });

      test('searches successfully', () async {
        expect(() async => await client.index('movies').search('name'),
            returnsNormally);
      });
    });

    group('When has a invalid key', () {
      setUp(() async {
        client = MeiliSearchClient(testServer, 'this-is-a-invalid-key');
      });

      tearDown(() {
        client = MeiliSearchClient(testServer, 'masterKey');
      });

      test('throws MeiliSearchApiException in getKeys call', () async {
        expect(() async => await client.getKeys(),
            throwsA(isA<MeiliSearchApiException>()));
      });
    });
  });
}
