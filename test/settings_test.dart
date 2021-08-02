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

    test('Getting, setting, and deleting filterable attributes', () async {
      final index = await client.createIndex(randomUid());
      final updatedFilterableAttributes = ['director', 'genres'];
      var response = await index
          .updateFilterableAttributes(updatedFilterableAttributes)
          .waitFor();
      expect(response.status, 'processed');
      var filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, updatedFilterableAttributes);
      response = await index.resetFilterableAttributes().waitFor();
      expect(response.status, 'processed');
      filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, []);
    });

    test('Getting, setting, and deleting displayed attributes', () async {
      final index = await client.createIndex(randomUid());
      final updatedDisplayedAttributes = ['genre', 'title'];
      var response = await index
          .updateDisplayedAttributes(updatedDisplayedAttributes)
          .waitFor();
      expect(response.status, 'processed');
      var displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, updatedDisplayedAttributes);
      response = await index.resetDisplayedAttributes().waitFor();
      expect(response.status, 'processed');
      displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, ['*']);
    });

    test('Getting, setting, and deleting distinct attribute', () async {
      final index = await client.createIndex(randomUid());
      final updatedDistinctAttribute = 'movie_id';
      var response = await index
          .updateDistinctAttribute(updatedDistinctAttribute)
          .waitFor();
      expect(response.status, 'processed');
      var distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, updatedDistinctAttribute);
      response = await index.resetDistinctAttribute().waitFor();
      expect(response.status, 'processed');
      distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, null);
    });

    test('Getting, setting, and deleting ranking rules', () async {
      final index = await client.createIndex(randomUid());
      final defaultRankingRules = await index.getRankingRules();
      final updatedRankingRules = [
        'exactness',
        'attribute',
        'proximity',
        'typo'
      ];
      var response =
          await index.updateRankingRules(updatedRankingRules).waitFor();
      expect(response.status, 'processed');
      final updatedRules = await index.getRankingRules();
      expect(updatedRules, updatedRankingRules);
      response = await index.resetRankingRules().waitFor();
      expect(response.status, 'processed');
      final resetRules = await index.getRankingRules();
      expect(resetRules, defaultRankingRules);
    });

    test('Getting, setting, and deleting searchable attributes', () async {
      final index = await client.createIndex(randomUid());
      final updatedSearchableAttributes = ['title', 'id'];
      var response = await index
          .updateSearchableAttributes(updatedSearchableAttributes)
          .waitFor();
      expect(response.status, 'processed');
      var searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, updatedSearchableAttributes);
      response = await index.resetSearchableAttributes().waitFor();
      expect(response.status, 'processed');
      searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, ['*']);
    });

    test('Getting, setting, and deleting stop words', () async {
      final index = await client.createIndex(randomUid());
      final updatedStopWords = ['a', 'of', 'the'];
      var response = await index.updateStopWords(updatedStopWords).waitFor();
      expect(response.status, 'processed');
      var stopWords = await index.getStopWords();
      expect(stopWords, updatedStopWords);
      response = await index.resetStopWords().waitFor();
      expect(response.status, 'processed');
      stopWords = await index.getStopWords();
      expect(stopWords, []);
    });

    test('Getting, setting, and deleting synonyms', () async {
      final index = await client.createIndex(randomUid());
      final updatedSynonyms = {
        'large': ['big'],
        'small': ['little']
      };
      var response = await index.updateSynonyms(updatedSynonyms).waitFor();
      expect(response.status, 'processed');
      final synonyms = await index.getSynonyms();
      expect(synonyms, updatedSynonyms);
      response = await index.resetSynonyms().waitFor();
      expect(response.status, 'processed');
      final resetSynonyms = await index.getSynonyms();
      expect(resetSynonyms, {});
    });
  });
}
