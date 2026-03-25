import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Experimental Features', () {
    setUpClient();

    test('getExperimentalFeatures returns network flag', () async {
      final features = await client.getExperimentalFeatures();
      // We don't know the default, but it should be a boolean if it exists in the response
      // For now, we just want to ensure we can access the field.
      // This will fail to compile if the field is missing.
      expect(features.network, isA<bool?>());
    });

    test('updateExperimentalFeatures updates network flag', () async {
      // Toggle it to true
      await client.updateExperimentalFeatures(
        const UpdateExperimentalFeatures(network: true),
      );

      var features = await client.getExperimentalFeatures();
      expect(features.network, isTrue);

      // Toggle it back to false
      await client.updateExperimentalFeatures(
        const UpdateExperimentalFeatures(network: false),
      );

      features = await client.getExperimentalFeatures();
      expect(features.network, isFalse);
    });
  });
}
