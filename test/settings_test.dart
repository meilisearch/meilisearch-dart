import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Settings', () {
    setUpClient();

    test('Getting the default settings', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);
      var settings = await index.getSettings();

      expect(settings.displayedAttributes, equals(['*']));
    });

    test('Update the settings', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      var response = await index
          .updateSettings(IndexSettings(
            stopWords: ['is', 'or', 'and', 'to'],
            displayedAttributes: ['name'],
            searchableAttributes: ['name'],
            synonyms: <String, List<String>>{
              'male': ['man'],
              'female': ['woman'],
            },
            distinctAttribute: 'movie_id',
            sortableAttributes: ['genre', 'title'],
          ))
          .waitFor();
      expect(response.status, 'succeeded');
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
      expect(settings.distinctAttribute, equals('movie_id'));
      expect(settings.sortableAttributes, equals(['genre', 'title']));
    });

    test('Reseting the settings', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      var response = await index
          .updateSettings(IndexSettings(displayedAttributes: ['displayName']))
          .waitFor();
      expect(response.status, 'succeeded');
      response = await index.resetSettings().waitFor();
      expect(response.status, 'succeeded');
      final settings = await index.getSettings();
      expect(settings.displayedAttributes, equals(['*']));
    });

    test('Getting, setting, and deleting filterable attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final updatedFilterableAttributes = ['director'];
      var response = await index
          .updateFilterableAttributes(updatedFilterableAttributes)
          .waitFor();
      expect(response.status, 'succeeded');
      var filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, updatedFilterableAttributes);
      response = await index.resetFilterableAttributes().waitFor();
      expect(response.status, 'succeeded');
      filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, []);
    });

    test('Getting, setting, and deleting displayed attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final updatedDisplayedAttributes = ['genre', 'title'];
      var response = await index
          .updateDisplayedAttributes(updatedDisplayedAttributes)
          .waitFor();
      expect(response.status, 'succeeded');
      var displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, updatedDisplayedAttributes);
      response = await index.resetDisplayedAttributes().waitFor();
      expect(response.status, 'succeeded');
      displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, ['*']);
    });

    test('Getting, setting, and deleting distinct attribute', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final updatedDistinctAttribute = 'movie_id';
      var response = await index
          .updateDistinctAttribute(updatedDistinctAttribute)
          .waitFor();
      expect(response.status, 'succeeded');
      var distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, updatedDistinctAttribute);
      response = await index.resetDistinctAttribute().waitFor();
      expect(response.status, 'succeeded');
      distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, null);
    });

    test('Getting, setting, and deleting ranking rules', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final defaultRankingRules = await index.getRankingRules();
      final updatedRankingRules = [
        'exactness',
        'attribute',
        'proximity',
        'typo'
      ];
      var response =
          await index.updateRankingRules(updatedRankingRules).waitFor();
      expect(response.status, 'succeeded');
      final updatedRules = await index.getRankingRules();
      expect(updatedRules, updatedRankingRules);
      response = await index.resetRankingRules().waitFor();
      expect(response.status, 'succeeded');
      final resetRules = await index.getRankingRules();
      expect(resetRules, defaultRankingRules);
    });

    test('Getting, setting, and deleting searchable attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final updatedSearchableAttributes = ['title', 'id'];
      var response = await index
          .updateSearchableAttributes(updatedSearchableAttributes)
          .waitFor();
      expect(response.status, 'succeeded');
      var searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, updatedSearchableAttributes);
      response = await index.resetSearchableAttributes().waitFor();
      expect(response.status, 'succeeded');
      searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, ['*']);
    });

    test('Getting, setting, and deleting stop words', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final updatedStopWords = ['a', 'of', 'the'];
      var response = await index.updateStopWords(updatedStopWords).waitFor();
      expect(response.status, 'succeeded');
      var stopWords = await index.getStopWords();
      expect(stopWords, updatedStopWords);
      response = await index.resetStopWords().waitFor();
      expect(response.status, 'succeeded');
      stopWords = await index.getStopWords();
      expect(stopWords, []);
    });

    test('Getting, setting, and deleting synonyms', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final updatedSynonyms = {
        'large': ['big'],
        'small': ['little']
      };
      var response = await index.updateSynonyms(updatedSynonyms).waitFor();
      expect(response.status, 'succeeded');
      final synonyms = await index.getSynonyms();
      expect(synonyms, updatedSynonyms);
      response = await index.resetSynonyms().waitFor();
      expect(response.status, 'succeeded');
      final resetSynonyms = await index.getSynonyms();
      expect(resetSynonyms, {});
    });

    test('Getting, setting, and deleting sortable attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor();
      var index = await client.getIndex(uid);

      final updatedSortableAttributes = ['genre', 'title'];
      var response = await index
          .updateSortableAttributes(updatedSortableAttributes)
          .waitFor();
      expect(response.status, 'succeeded');
      final sortableAttributes = await index.getSortableAttributes();
      expect(sortableAttributes, updatedSortableAttributes);
      response = await index.resetSortableAttributes().waitFor();
      final resetSortablettributes = await index.getSortableAttributes();
      expect(resetSortablettributes, []);
    });
  });
}
