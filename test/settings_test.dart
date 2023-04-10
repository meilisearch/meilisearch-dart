import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Settings', () {
    setUpClient();

    test('Getting the default settings', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);
      var settings = await index.getSettings();

      expect(settings.displayedAttributes, equals(['*']));
    });

    test('Update the settings', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      var response = await index
          .updateSettings(
            IndexSettings(
              stopWords: ['is', 'or', 'and', 'to'],
              displayedAttributes: ['name'],
              searchableAttributes: ['name'],
              synonyms: <String, List<String>>{
                'male': ['man'],
                'female': ['woman'],
              },
              distinctAttribute: 'movie_id',
              sortableAttributes: ['genre', 'title'],
              typoTolerance: TypoTolerance(
                disableOnAttributes: ['genre'],
                disableOnWords: ['prince'],
                enabled: true,
                minWordSizeForTypos: MinWordSizeForTypos(
                  oneTypo: 3,
                ),
              ),
              faceting: Faceting(
                maxValuesPerFacet: 200,
              ),
            ),
          )
          .waitFor(client: client);

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
      expect(settings.typoTolerance?.disableOnAttributes, contains('genre'));
      expect(settings.typoTolerance?.disableOnWords, contains('prince'));
      expect(settings.typoTolerance?.minWordSizeForTypos?.oneTypo, equals(3));
      expect(settings.faceting?.maxValuesPerFacet, equals(200));
    });

    test('Reseting the settings', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      var response = await index
          .updateSettings(IndexSettings(displayedAttributes: ['displayName']))
          .waitFor(client: client);
      expect(response.status, 'succeeded');
      response = await index.resetSettings().waitFor(client: client);
      expect(response.status, 'succeeded');
      final settings = await index.getSettings();
      expect(settings.displayedAttributes, equals(['*']));
    });

    test('Getting, setting, and deleting filterable attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final updatedFilterableAttributes = ['director'];
      var response = await index
          .updateFilterableAttributes(updatedFilterableAttributes)
          .waitFor(client: client);
      expect(response.status, 'succeeded');
      var filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, updatedFilterableAttributes);
      response =
          await index.resetFilterableAttributes().waitFor(client: client);
      expect(response.status, 'succeeded');
      filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, <String>[]);
    });

    test('Getting, setting, and deleting displayed attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final updatedDisplayedAttributes = ['genre', 'title'];
      var response = await index
          .updateDisplayedAttributes(updatedDisplayedAttributes)
          .waitFor(client: client);
      expect(response.status, 'succeeded');
      var displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, updatedDisplayedAttributes);
      response = await index.resetDisplayedAttributes().waitFor(client: client);
      expect(response.status, 'succeeded');
      displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, ['*']);
    });

    test('Getting, setting, and deleting distinct attribute', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final updatedDistinctAttribute = 'movie_id';
      var response = await index
          .updateDistinctAttribute(updatedDistinctAttribute)
          .waitFor(client: client);
      expect(response.status, 'succeeded');
      var distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, updatedDistinctAttribute);
      response = await index.resetDistinctAttribute().waitFor(client: client);
      expect(response.status, 'succeeded');
      distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, null);
    });

    test('Getting, setting, and deleting ranking rules', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final defaultRankingRules = await index.getRankingRules();
      final updatedRankingRules = [
        'exactness',
        'attribute',
        'proximity',
        'typo'
      ];
      var response = await index
          .updateRankingRules(updatedRankingRules)
          .waitFor(client: client);
      expect(response.status, 'succeeded');
      final updatedRules = await index.getRankingRules();
      expect(updatedRules, updatedRankingRules);
      response = await index.resetRankingRules().waitFor(client: client);
      expect(response.status, 'succeeded');
      final resetRules = await index.getRankingRules();
      expect(resetRules, defaultRankingRules);
    });

    test('Getting, setting, and deleting searchable attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final updatedSearchableAttributes = ['title', 'id'];
      var response = await index
          .updateSearchableAttributes(updatedSearchableAttributes)
          .waitFor(client: client);
      expect(response.status, 'succeeded');
      var searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, updatedSearchableAttributes);
      response =
          await index.resetSearchableAttributes().waitFor(client: client);
      expect(response.status, 'succeeded');
      searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, ['*']);
    });

    test('Getting, setting, and deleting stop words', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final updatedStopWords = ['a', 'of', 'the'];
      var response =
          await index.updateStopWords(updatedStopWords).waitFor(client: client);
      expect(response.status, 'succeeded');
      var stopWords = await index.getStopWords();
      expect(stopWords, updatedStopWords);
      response = await index.resetStopWords().waitFor(client: client);
      expect(response.status, 'succeeded');
      stopWords = await index.getStopWords();
      expect(stopWords, <String>[]);
    });

    test('Getting, setting, and deleting synonyms', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final updatedSynonyms = {
        'large': ['big'],
        'small': ['little']
      };
      var response =
          await index.updateSynonyms(updatedSynonyms).waitFor(client: client);
      expect(response.status, 'succeeded');
      final synonyms = await index.getSynonyms();
      expect(synonyms, updatedSynonyms);
      response = await index.resetSynonyms().waitFor(client: client);
      expect(response.status, 'succeeded');
      final resetSynonyms = await index.getSynonyms();
      expect(resetSynonyms, <String, List<String>>{});
    });

    test('Getting, setting, and deleting sortable attributes', () async {
      final uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      var index = await client.getIndex(uid);

      final updatedSortableAttributes = ['genre', 'title'];
      var response = await index
          .updateSortableAttributes(updatedSortableAttributes)
          .waitFor(client: client);
      expect(response.status, 'succeeded');
      final sortableAttributes = await index.getSortableAttributes();
      expect(sortableAttributes, updatedSortableAttributes);
      response = await index.resetSortableAttributes().waitFor(client: client);
      final resetSortablettributes = await index.getSortableAttributes();
      expect(resetSortablettributes, <String>[]);
    });

    group('Typo Tolerance', () {
      late MeiliSearchIndex index;
      setUp(() async {
        final uid = randomUid();
        await client.createIndex(uid).waitFor(client: client);
        index = await client.getIndex(uid);
      });

      Future<TypoTolerance> doUpdate() async {
        final toUpdate = TypoTolerance(
          enabled: false,
          disableOnWords: ["hello", "world"],
          disableOnAttributes: [
            'attribute',
            'hello',
          ],
          minWordSizeForTypos: MinWordSizeForTypos(
            oneTypo: 4,
            twoTypos: 10,
          ),
        );
        var response =
            await index.updateTypoTolerance(toUpdate).waitFor(client: client);

        expect(response.status, "succeeded");
        return toUpdate;
      }

      test("Get", () async {
        final initial = await index.getTypoTolerance();
        final initialFromSettings =
            await index.getSettings().then((value) => value.typoTolerance);

        expect(
          initial.toMap(),
          equals(initialFromSettings?.toMap()),
        );
      });

      test("Update", () async {
        final toUpdate = await doUpdate();

        final afterUpdate = await index.getTypoTolerance();
        final afterUpdateFromSettings =
            await index.getSettings().then((value) => value.typoTolerance);

        expect(
          afterUpdateFromSettings?.toMap(),
          equals(toUpdate.toMap()),
        );
        expect(
          afterUpdate.toMap(),
          equals(toUpdate.toMap()),
        );
      });

      test("Reset", () async {
        //first update, then reset
        await doUpdate();
        final response =
            await index.resetTypoTolerance().waitFor(client: client);

        expect(response.status, 'succeeded');
        final afterReset = await index.getTypoTolerance();
        final afterResetFromSettings =
            await index.getSettings().then((value) => value.typoTolerance);
        expect(
          afterReset.toMap(),
          equals(TypoTolerance().toMap()),
        );
        expect(
          afterResetFromSettings?.toMap(),
          equals(TypoTolerance().toMap()),
        );
      });
    });

    group('Pagination', () {
      late MeiliSearchIndex index;
      setUp(() async {
        final uid = randomUid();
        await client.createIndex(uid).waitFor(client: client);
        index = await client.getIndex(uid);
      });

      Future<Pagination> doUpdate() async {
        final toUpdate = Pagination(
          maxTotalHits: 2000,
        );
        var response =
            await index.updatePagination(toUpdate).waitFor(client: client);

        expect(response.status, "succeeded");
        return toUpdate;
      }

      test("Get", () async {
        final initial = await index.getPagination();
        final initialFromSettings =
            await index.getSettings().then((value) => value.pagination);

        expect(
          initial.toMap(),
          equals(initialFromSettings?.toMap()),
        );
      });

      test("Update", () async {
        final toUpdate = await doUpdate();

        final afterUpdate = await index.getPagination();
        final afterUpdateFromSettings =
            await index.getSettings().then((value) => value.pagination);
        expect(
          afterUpdateFromSettings?.toMap(),
          equals(toUpdate.toMap()),
        );
        expect(
          afterUpdate.toMap(),
          equals(toUpdate.toMap()),
        );
      });

      test("Reset", () async {
        //first update, then reset
        await doUpdate();
        final response = await index.resetPagination().waitFor(client: client);

        expect(response.status, 'succeeded');
        final afterReset = await index.getPagination();
        final afterResetFromSettings =
            await index.getSettings().then((value) => value.pagination);
        expect(
          afterReset.toMap(),
          equals(Pagination().toMap()),
        );
        expect(
          afterResetFromSettings?.toMap(),
          equals(Pagination().toMap()),
        );
      });
    });

    group('Faceting', () {
      late MeiliSearchIndex index;
      setUp(() async {
        final uid = randomUid();
        await client.createIndex(uid).waitFor(client: client);
        index = await client.getIndex(uid);
      });

      Future<Faceting> doUpdate() async {
        final toUpdate = Faceting(
          maxValuesPerFacet: 200,
        );
        var response =
            await index.updateFaceting(toUpdate).waitFor(client: client);

        expect(response.status, "succeeded");
        return toUpdate;
      }

      test("Get", () async {
        final initial = await index.getFaceting();
        final initialFromSettings =
            await index.getSettings().then((value) => value.faceting);

        expect(
          initial.toMap(),
          equals(initialFromSettings?.toMap()),
        );
      });

      test("Update", () async {
        final toUpdate = await doUpdate();

        final afterUpdate = await index.getFaceting();
        final afterUpdateFromSettings =
            await index.getSettings().then((value) => value.faceting);
        expect(
          afterUpdateFromSettings?.toMap(),
          equals(toUpdate.toMap()),
        );
        expect(
          afterUpdate.toMap(),
          equals(toUpdate.toMap()),
        );
      });

      test("Reset", () async {
        //first update, then reset
        await doUpdate();
        final response = await index.resetFaceting().waitFor(client: client);

        expect(response.status, 'succeeded');
        final afterReset = await index.getFaceting();
        final afterResetFromSettings =
            await index.getSettings().then((value) => value.faceting);
        expect(
          afterReset.toMap(),
          equals(Faceting().toMap()),
        );
        expect(
          afterResetFromSettings?.toMap(),
          equals(Faceting().toMap()),
        );
      });
    });
  });
}
