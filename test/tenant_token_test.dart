import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/tenant_token.dart';
import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/client.dart';

void main() {
  final Map<String, dynamic> _searchRules = {"*": null};

  group('Tenant Tokens', () {
    setUpClient();

    final List<dynamic> possibleRules = [
      {'*': {}},
      {'*': null},
      ['*'],
      {
        '*': {"filter": 'tag = Tale'}
      },
      {"books": {}},
      {"books": null},
      ['books'],
      {
        "books": {"filter": 'tag = comedy AND book_id = 1'}
      }
    ];

    group('client.generateTenantToken', () {
      test('decodes successfully using apiKey from instance', () {
        final token = client.generateTenantToken(_searchRules);

        expect(() => JWT.verify(token, SecretKey(client.apiKey!)),
            returnsNormally);
      });

      test('decodes successfully using apiKey from param', () {
        final key = sha1RandomString();
        final token = client.generateTenantToken(_searchRules, apiKey: key);

        expect(() => JWT.verify(token, SecretKey(key)), returnsNormally);
      });

      test('throws InvalidApiKeyException if all given keys are invalid', () {
        final custom = MeiliSearchClient(testServer, null);

        expect(() => custom.generateTenantToken(_searchRules),
            throwsA(isA<InvalidApiKeyException>()));
      });

      test('invokes search successfully with the new token', () async {
        final admKey = await client.createKey(indexes: ["*"], actions: ["*"]);
        final admClient = MeiliSearchClient(testServer, admKey.key);
        await createBooksIndex(uid: 'books');
        await admClient
            .index('books')
            .updateFilterableAttributes(['tag', 'book_id']).waitFor();

        possibleRules.forEach((data) async {
          final token = admClient.generateTenantToken(data);
          final custom = MeiliSearchClient(testServer, token);

          expect(() async => await custom.index('books').search(''),
              returnsNormally);
        });
      });
    });

    group('tenant_token.generateToken', () {
      test('generates a signed token with given key', () {
        final key = sha1RandomString();
        final token = generateToken(_searchRules, key);

        expect(() => JWT.verify(token, SecretKey(key)), returnsNormally);
        expect(() => JWT.verify(token, SecretKey('not-the-same-key')),
            throwsA(isA<JWTError>()));
      });

      test('does not generate a signed token without a key', () {
        expect(() => generateToken(_searchRules, ''),
            throwsA(isA<InvalidApiKeyException>()));
      });

      test('generates a signed token with a given expiration', () {
        final key = sha1RandomString();
        final tomorrow = DateTime.now().add(new Duration(days: 1)).toUtc();
        final token = generateToken(_searchRules, key, expiresAt: tomorrow);

        expect(() => JWT.verify(token, SecretKey(key), checkExpiresIn: true),
            returnsNormally);
      });

      test('generates a signed token without expiration', () {
        final key = sha1RandomString();
        final token = generateToken(_searchRules, key, expiresAt: null);

        expect(() => JWT.verify(token, SecretKey(key), checkExpiresIn: true),
            returnsNormally);
      });

      test('throws ExpiredSignatureException when expiresAt is in the past',
          () {
        final key = sha1RandomString();
        final oldDate = DateTime.utc(1995, 12, 20);

        expect(() => generateToken(_searchRules, key, expiresAt: oldDate),
            throwsA(isA<ExpiredSignatureException>()));
      });

      test('throws NotUTCException if expiresAt are in localDate', () {
        final key = sha1RandomString();
        final localDate = DateTime(2300, 1, 20);

        expect(() => generateToken(_searchRules, key, expiresAt: localDate),
            throwsA(isA<NotUTCException>()));
      });
      test('contains apiKeyPrefix claim', () {
        final key = sha1RandomString();
        final token = generateToken(_searchRules, key);
        final claims = JWT.verify(token, SecretKey(key)).payload;

        expect(claims['apiKeyPrefix'], contains(key.substring(0, 8)));
      });
    });
  });
}
