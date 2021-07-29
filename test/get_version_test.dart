import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Keys', () {
    setUpClient();

    test('version is returned from the server', () async {
      var keys = await client.getVersion();
      expect(keys.keys, contains('commitSha'));
      expect(keys.keys, contains('buildDate'));
      expect(keys.keys, contains('pkgVersion'));
      expect(keys['commitSha'], isNotEmpty);
      expect(keys['buildDate'], isNotEmpty);
      expect(keys['pkgVersion'], isNotEmpty);
    });
  });
}
