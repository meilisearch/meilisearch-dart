import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/tenant_token.dart';
import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  final Map<String, Object?> searchRules = {"*": null};

  group('Tenant Tokens', () {
    setUpClient();

    final List<Object> possibleRules = [
      {'*': <String, Object?>{}},
      {'*': null},
      ['*'],
      {
        '*': {"filter": 'tag = Tale'}
      },
      {"my_index": <String, Object?>{}},
      {"my_index": null},
      ['my_index'],
      {
        "my_index": {"filter": 'tag = comedy AND book_id = 1'}
      }
    ];

    group('client.generateTenantToken', () {
      test('decodes successfully using apiKey from instance', () {
        final token = client.generateTenantToken('uid', searchRules);

        expect(
          () => JWT.verify(token, SecretKey(client.apiKey!)),
          returnsNormally,
        );
      });

      test('decodes successfully using uid from param', () {
        final key = sha1RandomString();
        final token =
            client.generateTenantToken('uid', searchRules, apiKey: key);

        expect(() => JWT.verify(token, SecretKey(key)), returnsNormally);
      });

      test('throws InvalidApiKeyException if all given keys are invalid', () {
        final custom = MeiliSearchClient(testServer, null);

        expect(
          () => custom.generateTenantToken('uid', searchRules),
          throwsA(isA<InvalidApiKeyException>()),
        );
      });

      test('invokes search successfully with the new token', () async {
        final admKey = await client.createKey(indexes: ["*"], actions: ["*"]);
        final admClient = MeiliSearchClient(testServer, admKey.key);
        final index = await createBooksIndex(uid: 'my_index');

        await index.updateFilterableAttributes(['tag', 'book_id']).waitFor(
          client: client,
        );

        await Future.wait(
          possibleRules.map((rule) {
            final token = admClient.generateTenantToken(admKey.uid!, rule);
            final custom = MeiliSearchClient(testServer, token);
            return custom.index('my_index').search('');
          }),
        );
      });
    });

    group('tenant_token.generateToken', () {
      test('generates a signed token with given key', () {
        final key = sha1RandomString();
        final uid = sha1RandomString();
        final token = generateToken(uid, searchRules, key);

        expect(() => JWT.verify(token, SecretKey(key)), returnsNormally);
        expect(() => JWT.verify(token, SecretKey('not-the-same-key')),
            throwsA(isA<JWTException>()));
      });

      test('does not generate a signed token without a key', () {
        expect(() => generateToken('', searchRules, ''),
            throwsA(isA<InvalidApiKeyException>()));
      });

      test('generates a signed token with a given expiration', () {
        final key = sha1RandomString();
        final uid = sha1RandomString();
        final tomorrow = DateTime.now().add(Duration(days: 1)).toUtc();
        final token = generateToken(uid, searchRules, key, expiresAt: tomorrow);

        expect(() => JWT.verify(token, SecretKey(key), checkExpiresIn: true),
            returnsNormally);
      });

      test('generates a signed token without expiration', () {
        final key = sha1RandomString();
        final uid = sha1RandomString();
        final token = generateToken(uid, searchRules, key, expiresAt: null);

        expect(() => JWT.verify(token, SecretKey(key), checkExpiresIn: true),
            returnsNormally);
      });

      test('throws ExpiredSignatureException when expiresAt is in the past',
          () {
        final key = sha1RandomString();
        final uid = sha1RandomString();
        final oldDate = DateTime.utc(1995, 12, 20);

        expect(() => generateToken(uid, searchRules, key, expiresAt: oldDate),
            throwsA(isA<ExpiredSignatureException>()));
      });

      test('throws NotUTCException if expiresAt are in localDate', () {
        final key = sha1RandomString();
        final uid = sha1RandomString();
        final localDate = DateTime(2300, 1, 20);

        expect(() => generateToken(uid, searchRules, key, expiresAt: localDate),
            throwsA(isA<NotUTCException>()));
      });
      test('contains custom claims', () {
        final key = sha1RandomString();
        final uid = sha1RandomString();
        final token = generateToken(uid, searchRules, key);
        final claims =
            JWT.verify(token, SecretKey(key)).payload as Map<String, Object?>;
        expect(claims['apiKeyUid'], equals(uid));
        expect(claims['searchRules'], equals(searchRules));
      });
    });
  });
}
