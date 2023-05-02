import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Health', () {
    setUpClient();

    test('of the server when the url is valid', () async {
      final health = await client.health();

      expect(health, {'status': 'available'});
    });

    test('of the server when the url is valid with isHealthy', () async {
      final health = await client.isHealthy();

      expect(health, true);
    });
  });

  group('Health Fail', () {
    late MeiliSearchClient badClient;
    setUp(() {
      final String server = 'http://wrongurl:1234';
      final connectTimeout = Duration(milliseconds: 1000);
      badClient = MeiliSearchClient(
        server,
        testApiKey,
        connectTimeout,
      );
    });

    test('when the url is not valid', () async {
      await expectLater(badClient.health(), throwsException);
    });

    test('when the url is not valid with isHealthy', () async {
      final health = await badClient.isHealthy();

      expect(health, false);
    });
  });
}
