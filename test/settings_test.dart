import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Settings', () {
    setUpClient();

    test('Getting the default settings', () async {
      var index = await client.createIndex(randomUid());
      var settings = await index.getSettings();
      expect(settings.displayedAttributes, equals(['*']));
    });

    test('Update the settings', () async {
      var index = await client.createIndex(randomUid());
      var update = await index.updateSettings(IndexSettings(
        stopWords: ['is', 'or', 'and', 'to'],
        displayedAttributes: ['name'],
        searchableAttributes: ['name'],
        synonyms: <String, List<String>>{
          'male': ['man'],
          'female': ['woman'],
        },
      ));
      await update.waitFor();
    });

    test('Resetting the settings', () async {
      var index = await client.createIndex(randomUid());
      await index
          .updateSettings(IndexSettings(displayedAttributes: ['displayName']))
          .waitFor();
      await index.resetSettings().waitFor();
      var settings = await index.getSettings();
      expect(settings.displayedAttributes, equals(['*']));
    });
  });
}
