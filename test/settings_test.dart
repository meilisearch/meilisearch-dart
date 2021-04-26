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
      final index = await client.createIndex(randomUid());
      var response = await index
          .updateSettings(IndexSettings(
            stopWords: ['is', 'or', 'and', 'to'],
            displayedAttributes: ['name'],
            searchableAttributes: ['name'],
            synonyms: <String, List<String>>{
              'male': ['man'],
              'female': ['woman'],
            },
          ))
          .waitFor();
      expect(response.status, 'processed');
      final settings = await index.getSettings();
      expect(settings.displayedAttributes, equals(['name']));
      expect(settings.searchableAttributes, equals(['name']));
      expect(settings.stopWords, contains('is'));
      expect(
          settings.synonyms,
          equals(<String, List<String>>{
            'male': ['man'],
            'female': ['woman'],
          }));
    });

    test('Resetting the settings', () async {
      final index = await client.createIndex(randomUid());
      var response = await index
          .updateSettings(IndexSettings(displayedAttributes: ['displayName']))
          .waitFor();
      expect(response.status, 'processed');
      response = await index.resetSettings().waitFor();
      expect(response.status, 'processed');
      final settings = await index.getSettings();
      expect(settings.displayedAttributes, equals(['*']));
    });
  });
}
