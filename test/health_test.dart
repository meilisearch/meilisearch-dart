import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Health', () {
    setUpClient();

    test('of the server when the url is valid', () async {
      var health = await client.health();
      expect(health, {'status': 'available'});
    });

    test('of the server when the url is valid with isHealthy', () async {
      var health = await client.isHealthy();
      expect(health, true);
    });
  });
  group('Health Fail', () {
    setUpClientWithWrongUrl();

    test('when the url is not valid', () async {
      expect(client.health(), throwsException);
    });

    test('when the url is not valid with isHealthy', () async {
      var health = await client.isHealthy();
      expect(health, false);
    });
  });
}
