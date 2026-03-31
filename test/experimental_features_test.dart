import 'package:meilisearch/src/results/experimental_features.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Experimental Features', () {
    setUpClient();

    test('getExperimentalFeatures returns network flag', () async {
      final features = await client.http.getExperimentalFeatures();
      // We don't know the default, but it should be a boolean if it exists in the response
      // For now, we just want to ensure we can access the field.
      // This will fail to compile if the field is missing.
      expect(features.network, isA<bool?>());
    });

    test('updateExperimentalFeatures updates network flag', () async {
      // Toggle it to true
      await client.http.updateExperimentalFeatures(
        const UpdateExperimentalFeatures(network: true),
      );

      var features = await client.http.getExperimentalFeatures();
      expect(features.network, isTrue);

      // Toggle it back to false
      await client.http.updateExperimentalFeatures(
        const UpdateExperimentalFeatures(network: false),
      );

      features = await client.http.getExperimentalFeatures();
      expect(features.network, isFalse);
    });
  });
}
