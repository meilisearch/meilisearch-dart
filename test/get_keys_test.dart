import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Keys', () {
    setUpClient();

    test('keys are returned from the server', () async {
      var keys = await client.getKeys();
      expect(keys.keys, contains('public'));
      expect(keys.keys, contains('private'));
      expect(keys['public'], isNotEmpty);
      expect(keys['private'], isNotEmpty);
    });
  });
}
