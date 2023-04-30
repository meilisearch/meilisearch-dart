import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Settings', () {
    setUpClient();
    late String uid;
    late MeiliSearchIndex index;

    setUp(() async {
      uid = randomUid();
      await client.createIndex(uid).waitFor(client: client);
      index = await client.getIndex(uid);
    });

    test('Getting the default settings', () async {
      final settings = await index.getSettings();

      expect(settings.displayedAttributes, equals(['*']));
    });

    test('Update the settings', () async {
      await index
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

      final settings = await index.getSettings();
      expect(settings.displayedAttributes, equals(['name']));
      expect(settings.searchableAttributes, equals(['name']));
      expect(settings.stopWords, contains('is'));
      expect(
        settings.synonyms,
        equals(<String, List<String>>{
          'male': ['man'],
          'female': ['woman'],
        }),
      );
      expect(settings.distinctAttribute, equals('movie_id'));
      expect(settings.sortableAttributes, equals(['genre', 'title']));
      expect(settings.typoTolerance?.disableOnAttributes, contains('genre'));
      expect(settings.typoTolerance?.disableOnWords, contains('prince'));
      expect(settings.typoTolerance?.minWordSizeForTypos?.oneTypo, equals(3));
      expect(settings.faceting?.maxValuesPerFacet, equals(200));
    });

    test('Reseting the settings', () async {
      await index
          .updateDisplayedAttributes(['displayName']).waitFor(client: client);
      await index.resetSettings().waitFor(client: client);

      final settings = await index.getSettings();

      expect(settings.displayedAttributes, equals(['*']));
    });

    test('Getting, setting, and deleting filterable attributes', () async {
      final updatedFilterableAttributes = ['director'];
      await index
          .updateFilterableAttributes(updatedFilterableAttributes)
          .waitFor(client: client);

      var filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, updatedFilterableAttributes);

      await index.resetFilterableAttributes().waitFor(client: client);

      filterableAttributes = await index.getFilterableAttributes();
      expect(filterableAttributes, <String>[]);
    });

    test('Getting, setting, and deleting displayed attributes', () async {
      final updatedDisplayedAttributes = ['genre', 'title'];
      await index
          .updateDisplayedAttributes(updatedDisplayedAttributes)
          .waitFor(client: client);
      var displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, updatedDisplayedAttributes);
      await index.resetDisplayedAttributes().waitFor(client: client);
      displayedAttributes = await index.getDisplayedAttributes();
      expect(displayedAttributes, ['*']);
    });

    test('Getting, setting, and deleting distinct attribute', () async {
      final updatedDistinctAttribute = 'movie_id';
      await index
          .updateDistinctAttribute(updatedDistinctAttribute)
          .waitFor(client: client);
      var distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, updatedDistinctAttribute);
      await index.resetDistinctAttribute().waitFor(client: client);
      distinctAttribute = await index.getDistinctAttribute();
      expect(distinctAttribute, null);
    });

    test('Getting, setting, and deleting ranking rules', () async {
      final defaultRankingRules = await index.getRankingRules();
      final updatedRankingRules = [
        'exactness',
        'attribute',
        'proximity',
        'typo'
      ];
      await index
          .updateRankingRules(updatedRankingRules)
          .waitFor(client: client);
      final updatedRules = await index.getRankingRules();
      expect(updatedRules, updatedRankingRules);
      await index.resetRankingRules().waitFor(client: client);
      final resetRules = await index.getRankingRules();
      expect(resetRules, defaultRankingRules);
    });

    test('Getting, setting, and deleting searchable attributes', () async {
      final updatedSearchableAttributes = ['title', 'id'];
      await index
          .updateSearchableAttributes(updatedSearchableAttributes)
          .waitFor(client: client);
      var searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, updatedSearchableAttributes);
      await index.resetSearchableAttributes().waitFor(client: client);
      searchableAttributes = await index.getSearchableAttributes();
      expect(searchableAttributes, ['*']);
    });

    test('Getting, setting, and deleting stop words', () async {
      final updatedStopWords = ['a', 'of', 'the'];

      await index.updateStopWords(updatedStopWords).waitFor(client: client);
      var stopWords = await index.getStopWords();
      expect(stopWords, updatedStopWords);
      await index.resetStopWords().waitFor(client: client);
      stopWords = await index.getStopWords();
      expect(stopWords, <String>[]);
    });

    test('Getting, setting, and deleting synonyms', () async {
      final updatedSynonyms = {
        'large': ['big'],
        'small': ['little']
      };

      await index.updateSynonyms(updatedSynonyms).waitFor(client: client);
      final synonyms = await index.getSynonyms();
      expect(synonyms, updatedSynonyms);
      await index.resetSynonyms().waitFor(client: client);
      final resetSynonyms = await index.getSynonyms();
      expect(resetSynonyms, <String, List<String>>{});
    });

    test('Getting, setting, and deleting sortable attributes', () async {
      final updatedSortableAttributes = ['genre', 'title'];
      await index
          .updateSortableAttributes(updatedSortableAttributes)
          .waitFor(client: client);
      final sortableAttributes = await index.getSortableAttributes();
      expect(sortableAttributes, updatedSortableAttributes);
      await index.resetSortableAttributes().waitFor(client: client);
      final resetSortablettributes = await index.getSortableAttributes();
      expect(resetSortablettributes, <String>[]);
    });

    group('Typo Tolerance', () {
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

        await index.updateTypoTolerance(toUpdate).waitFor(client: client);

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
