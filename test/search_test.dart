import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/books_data.dart';
import 'utils/client.dart';
import 'utils/wait_for.dart';

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
      expect(result.hits, hasLength(books.length));
    });

    test('with basic query with an empty string q=""', () async {
      var index = await createBooksIndex();
      var result = await index.search('');
      expect(result.hits, hasLength(books.length));
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
        var result = await index.search('Alice In Wonderland', attributesToCrop: ["title"], cropLength: 2);
        expect((result.hits![0]['_formatted'] as Map<String, Object?>)['title'], equals('Alice In…'));
      });

      test('searches with default cropping parameters', () async {
        var index = await createBooksIndex();
        var result = await index.search('prince', attributesToCrop: ['*'], cropLength: 2);

        expect((result.hits![0]['_formatted'] as Map<String, Object?>)['title'], equals('…Petit Prince'));
      });

      test('searches with custom cropMarker', () async {
        var index = await createBooksIndex();
        var result = await index.search('prince', attributesToCrop: ['*'], cropLength: 1, cropMarker: '[…] ');

        expect((result.hits![0]['_formatted'] as Map<String, Object?>)['title'], equals('[…] Prince'));
      });

      test('searches with custom highlight tags', () async {
        var index = await createBooksIndex();
        var result = await index.search('blood', attributesToHighlight: ['*'], highlightPreTag: '<mark>', highlightPostTag: '</mark>');

        expect((result.hits![0]['_formatted'] as Map<String, Object?>)['title'], equals('Harry Potter and the Half-<mark>Blood</mark> Prince'));
      });

      test('searches with matching strategy last', () async {
        var index = await createBooksIndex();
        var result = await index.search(
          'the to',
          matchingStrategy: MatchingStrategy.last,
        );

        expect(result.hits!.last['title'], equals('Harry Potter and the Half-Blood Prince'));
      });

      test('searches with matching strategy all', () async {
        var index = await createBooksIndex();
        var result = await index.search(
          'the to',
          matchingStrategy: MatchingStrategy.all,
        );

        expect(result.hits!.last['title'], equals('The Hitchhiker\'s Guide to the Galaxy'));
      });

      test('searches with matching strategy as null if not set', () async {
        var index = await createBooksIndex();
        var result = await index.search(
          'the to',
        );

        expect(result.hits!.last['title'], equals('Harry Potter and the Half-Blood Prince'));
      });

      test('filter expression parameter', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor(client: client);
        expect(response.status, 'succeeded');
        var result = await index.search(
          'prince',
          filterExpression: Meili.eq(
            Meili.path('tag'),
            Meili.value("Tale"),
          ),
        );
        expect(result.hits, hasLength(1));
      });

      test('filter parameter', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor(client: client);
        expect(response.status, 'succeeded');
        var result = await index.search('prince', filter: 'tag = Tale');
        expect(result.hits, hasLength(1));
      });

      test('filter parameter with spaces', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor(client: client);
        expect(response.status, 'succeeded');
        var result = await index.search('prince', filter: 'tag = "Epic fantasy"');
        expect(result.hits, hasLength(1));
      });

      test('filter parameter with number', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag', 'book_id'],
            ))
            .waitFor(client: client);
        expect(response.status, 'succeeded');
        var result = await index.search('', filter: 'book_id < 100 AND tag = Tale');
        expect(result.hits, hasLength(1));
      });

      test('filter parameter with array', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(IndexSettings(
              filterableAttributes: ['tag'],
            ))
            .waitFor(client: client);
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
            .waitFor(client: client);
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
            .waitFor(client: client);
        expect(response.status, 'succeeded');
        var result = await index.search('prince', facets: ['*']);
        expect(result.hits, hasLength(2));
      });

      test('Sort parameter', () async {
        var index = await createBooksIndex();
        var response = await index
            .updateSettings(
                IndexSettings(sortableAttributes: ['title'], rankingRules: ['words', 'sort', 'typo', 'proximity', 'attribute', 'exactness']))
            .waitFor(client: client);
        expect(response.status, 'succeeded');
        var result = await index.search('prince', sort: ['title:asc']);
        expect(result.hits, hasLength(2));
        expect(result.hits![0]['book_id'], 4);
      });
    });

    test('searches within nested content with no parameters', () async {
      var index = await createNestedBooksIndex();
      var response = await index.search('An awesome');

      expect(response.hits![0], {
        "id": 5,
        "title": 'The Hobbit',
        "info": {
          "comment": 'An awesome book',
          "reviewNb": 900,
        },
      });
    });

    test('searches on nested content with searchable on specific nested field', () async {
      var index = await createNestedBooksIndex();
      await index.updateSettings(IndexSettings(searchableAttributes: ['title', 'info.comment'])).waitFor(client: client);

      var response = await index.search('An awesome');

      expect(response.hits![0], {
        "id": 5,
        "title": 'The Hobbit',
        "info": {
          "comment": 'An awesome book',
          "reviewNb": 900,
        },
      });
    });

    test('searches on nested content with content with sort', () async {
      var index = await createNestedBooksIndex();
      await index
          .updateSettings(IndexSettings(searchableAttributes: ['title', 'info.comment'], sortableAttributes: ['info.reviewNb']))
          .waitFor(client: client);

      var response = await index.search('', sort: ['info.reviewNb:desc']);

      expect(response.hits![0], {
        "id": 6,
        "title": 'Harry Potter and the Half-Blood Prince',
        "info": {
          "comment": 'The best book',
          "reviewNb": 1000,
        },
      });
    });
  });

  group('with finite-pagination query params', () {
    test('with basic query', () async {
      var index = await createBooksIndex();
      var result = await index.search('pri', page: 1) as PaginatedSearchResult;

      expect(result.totalPages, 1);
    });

    test('accesses fields from Searchable', () async {
      var index = await createBooksIndex();
      var result = await index.search('pri', page: 1) as PaginatedSearchResult;

      expect(result.hits!.length, greaterThanOrEqualTo(1));
      expect(result.totalPages, 1);
    });

    test('with mixed pagination query params', () async {
      var index = await createBooksIndex();
      var result = await index.search('pri', page: 1, limit: 10) as PaginatedSearchResult;

      expect(result.totalPages, 1);
    });
  });
}
