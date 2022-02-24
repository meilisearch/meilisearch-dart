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
        final tomorrow = DateTime.now().add(new Duration(days: 1));
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

      test('contains apiKeyPrefix claim', () {
        final key = sha1RandomString();
        final token = generateToken(_searchRules, key);
        final claims = JWT.verify(token, SecretKey(key)).payload;

        expect(claims['apiKeyPrefix'], contains(key.substring(0, 8)));
      });
    });
  });
}
