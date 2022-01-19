import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/client.dart';

void main() {
  group('Search', () {
    setUpClient();

    test('with basic query', () async {
      var index = await createBooksIndex();
      var result = await index.search('prience'); // with typo
      expect(result.hits, hasLength(2));
    });

    test('with basic query with no q', () async {
      var index = await createBooksIndex();
      var result = await index.search(null);
      expect(result.hits, hasLength(booksDoc.length));
    });

    test('with basic query with an empty string q=""', () async {
      var index = await createBooksIndex();
      var result = await index.search('');
      expect(result.hits, hasLength(booksDoc.length));
    });

    test('with basic query with phrase search', () async {
      var index = await createBooksIndex();
      var result = await index.search('coco "harry"');
      expect(result.hits, hasLength(1));
    });

    group('with', () {
      test('offset parameter', () async {
        var index = await createBooksIndex();
        var result = await index.search('', limit: 3, offset: 10);
        expect(result.hits, isEmpty);
      });

      test('limit parameter', () async {
        var index = await createBooksIndex();
        var result = await index.search('', limit: 3);
        expect(result.hits, hasLength(3));
      });

      test('cropLength parameter', () async {
        var index = await createBooksIndex();
        var result = await index.search('Alice In Wonderland',
            attributesToCrop: ["title"], cropLength: 2);
        expect(result.hits![0]['_formatted']['title'], equals('Alice In'));
      });

      test('filter parameter', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor();
        expect(response.status, 'succeeded');
        var result = await index.search('prince', filter: 'tag = Tale');
        expect(result.hits, hasLength(1));
      });

      test('filter parameter with number', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag', 'book_id'],
            ))
            .waitFor();
        expect(response.status, 'succeeded');
        var result =
            await index.search('', filter: 'book_id < 100 AND tag = Tale');
        expect(result.hits, hasLength(1));
      });

      test('filter parameter with array', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor();
        expect(response.status, 'succeeded');
        var result = await index.search('prince', filter: ['tag = Tale']);
        expect(result.hits, hasLength(1));
      });

      test('filter parameter with multiple array', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor();
        expect(response.status, 'succeeded');
        var result = await index.search('prince', filter: [
          ['tag = Tale', 'tag = Tale'],
          'tag = Tale'
        ]);
        expect(result.hits, hasLength(1));
      });

      test('facetDistributions parameter', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor();
        expect(response.status, 'succeeded');
        var result = await index.search('prince', facetsDistribution: ['*']);
        expect(result.hits, hasLength(2));
      });

      test('Sort parameter', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(sortableAttributes: [
              'title'
            ], rankingRules: [
              'words',
              'sort',
              'typo',
              'proximity',
              'attribute',
              'exactness'
            ]))
            .waitFor();
        expect(response.status, 'succeeded');
        var result = await index.search('prince', sort: ['title:asc']);
        expect(result.hits, hasLength(2));
        expect(result.hits![0]['book_id'], 4);
      });
    });
  });
}
