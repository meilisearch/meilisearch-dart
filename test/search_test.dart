import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/books_data.dart';
import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Search', () {
    setUpClient();
    late String uid;
    late MeiliSearchIndex index;

    setUp(() {
      uid = randomUid();
    });

    group('Books', () {
      setUp(() async {
        index = await createBooksIndex(uid: uid);
      });

      test('map', () async {
        //search
        //if deserialization fails it will throw
        final castedResult =
            await index.search('').asSearchResult().map(BookDto.fromMap);
        //test
        expect(castedResult.hits, everyElement(isA<BookDto>()));
      });

      test('with basic query', () async {
        final result = await index.search('prience'); // with typo

        expect(result.hits, hasLength(2));
      });

      test('with basic query with no q', () async {
        final result = await index.search(null);

        expect(result.hits, hasLength(books.length));
      });

      test('with basic query with an empty string q=""', () async {
        final result = await index.search('');

        expect(result.hits, hasLength(books.length));
      });

      test('with basic query with phrase search', () async {
        final result = await index.search('coco "harry"');

        expect(result.hits, hasLength(1));
      });

      group('with', () {
        test('offset parameter', () async {
          final result =
              await index.search('', SearchQuery(limit: 3, offset: 10));

          expect(result.hits, isEmpty);
        });

        test('limit parameter', () async {
          final result = await index.search('', SearchQuery(limit: 3));

          expect(result.hits, hasLength(3));
        });

        test('cropLength parameter', () async {
          final result = await index.search(
            'Alice In Wonderland',
            SearchQuery(
              attributesToCrop: ["title"],
              cropLength: 2,
            ),
          );

          expect(
            result.hits[0]['_formatted']['title'],
            equals('Alice In…'),
          );
        });

        test('searches with default cropping parameters', () async {
          final result = await index.search(
            'prince',
            SearchQuery(
              attributesToCrop: ['*'],
              cropLength: 2,
            ),
          );

          expect(
            result.hits[0]['_formatted']['title'],
            equals('…Petit Prince'),
          );
        });

        test('searches with custom cropMarker', () async {
          final result = await index.search(
            'prince',
            SearchQuery(
              attributesToCrop: ['*'],
              cropLength: 1,
              cropMarker: '[…] ',
            ),
          );

          expect(result.hits[0]['_formatted']['title'], equals('[…] Prince'));
        });

        test('searches with custom highlight tags', () async {
          final result = await index.search(
            'blood',
            SearchQuery(
              attributesToHighlight: ['*'],
              highlightPreTag: '<mark>',
              highlightPostTag: '</mark>',
            ),
          );

          expect(
            result.hits[0]['_formatted']['title'],
            equals('Harry Potter and the Half-<mark>Blood</mark> Prince'),
          );
        });

        test('searches with matching strategy last', () async {
          final result = await index.search(
            'the to',
            SearchQuery(
              matchingStrategy: MatchingStrategy.last,
            ),
          );

          expect(
            result.hits.last['title'],
            equals('Harry Potter and the Half-Blood Prince'),
          );
        });

        test('searches with matching strategy all', () async {
          final result = await index.search(
            'the to',
            SearchQuery(
              matchingStrategy: MatchingStrategy.all,
            ),
          );

          expect(
            result.hits.last['title'],
            equals('The Hitchhiker\'s Guide to the Galaxy'),
          );
        });

        test('searches with matching strategy as null if not set', () async {
          final result = await index.search('the to');

          expect(
            result.hits.last['title'],
            equals('Harry Potter and the Half-Blood Prince'),
          );
        });

        test('filter parameter', () async {
          await index
              .updateFilterableAttributes(['tag']).waitFor(client: client);

          final result =
              await index.search('prince', SearchQuery(filter: '"tag" = Tale'));

          expect(result.hits, hasLength(1));
        });

        test('filter parameter is null', () async {
          var index = await createBooksIndex();
          await index
              .updateFilterableAttributes(['tag']).waitFor(client: client);

          var result = await index.search(
            'The Hobbit',
            SearchQuery(filterExpression: 'tag'.toMeiliAttribute().isNull()),
          );

          expect(result.hits, hasLength(1));
          expect(result.hits.first["book_id"], equals(9999));
        });

        test('filter parameter with spaces', () async {
          await index
              .updateFilterableAttributes(['tag']).waitFor(client: client);

          final result = await index.search(
            'prince',
            SearchQuery(
              filter: 'tag = "Epic fantasy"',
            ),
          );

          expect(result.hits, hasLength(1));
        });

        test('facetStats parameter', () async {
          final indexWithNumbers = client.index(randomUid());
          final docs = List.generate(
            10,
            (index) => <String, Object?>{
              'id': 100 - index,
              'year': (index * 2) + 2010,
            },
          );
          await indexWithNumbers.addDocuments(docs).waitFor(client: client);
          await indexWithNumbers
              .updateFilterableAttributes(['year']).waitFor(client: client);

          var result =
              await indexWithNumbers.search('', SearchQuery(facets: ['*']));

          expect(result.hits, hasLength(10));
          expect(result.facetStats?['year']?.min, 2010);
          expect(result.facetStats?['year']?.max, 2028);
        });

        group('facet search', () {
          setUp(() async {
            await index.updateFilterableAttributes(
              ['tag', 'book_id'],
            ).waitFor(client: client);
          });

          test('basic', () async {
            final facetSearchRes = await index.facetSearch(
              FacetSearchQuery(
                facetName: 'tag',
                facetQuery: 't',
              ),
            );

            expect(facetSearchRes.facetHits, hasLength(1));
            expect(facetSearchRes.facetHits[0].count, 2);
            expect(facetSearchRes.facetHits[0].value, "Tale");
            expect(facetSearchRes.facetQuery, "t");
          });

          test('With additional search params', () async {
            final facetSearchRes = await index.facetSearch(
              FacetSearchQuery(facetName: 'tag', facetQuery: 't', q: 'hobbit'),
            );

            expect(facetSearchRes.facetHits, hasLength(0));
            expect(facetSearchRes.facetQuery, "t");
          });
        });

        test('filter parameter with number', () async {
          await index.updateFilterableAttributes(
            ['tag', 'book_id'],
          ).waitFor(client: client);

          final result = await index.search(
            '',
            SearchQuery(
              filter: 'book_id < 100 AND tag = Tale',
            ),
          );

          expect(result.hits, hasLength(1));
        });

        test('filter parameter with array', () async {
          await index
              .updateFilterableAttributes(['tag']).waitFor(client: client);

          final result =
              await index.search('prince', SearchQuery(filter: ['tag = Tale']));

          expect(result.hits, hasLength(1));
        });

        test('filter parameter with multiple array', () async {
          await index
              .updateFilterableAttributes(['tag']).waitFor(client: client);

          final result = await index.search(
            'prince',
            SearchQuery(filter: [
              ['tag = Tale', 'tag = Tale'],
              'tag = Tale'
            ]),
          );

          expect(result.hits, hasLength(1));
        });

        test('facetDistributions parameter', () async {
          await index
              .updateFilterableAttributes([ktag]).waitFor(client: client);

          final result =
              await index.search('prince', SearchQuery(facets: ['*']));

          expect(result.hits, hasLength(2));
          expect(result.facetDistribution?[ktag]?.length, 2);
        });

        test('Sort parameter', () async {
          await index
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
              .waitFor(client: client);

          final result =
              await index.search('prince', SearchQuery(sort: ['title:asc']));

          expect(result.hits, hasLength(2));
          expect(result.hits[0]['book_id'], 4);
        });

        group('finite-pagination query params', () {
          test('with basic query', () async {
            final result = await index
                .search('pri', SearchQuery(page: 1))
                .asPaginatedResult();

            expect(result.totalPages, 1);
          });

          test('accesses fields from Searchable', () async {
            final result = await index
                .search('pri', SearchQuery(page: 1))
                .asPaginatedResult();

            expect(result.hits.length, greaterThanOrEqualTo(1));
            expect(result.totalPages, 1);
          });

          test('with mixed pagination query params', () async {
            final result = await index
                .search('pri', SearchQuery(page: 1, limit: 10))
                .asPaginatedResult();

            expect(result.totalPages, 1);
          });
        });
      });
    });

    group('Nested Books', () {
      setUp(() async {
        index = await createNestedBooksIndex(uid: uid);
      });

      test('searches within nested content with no parameters', () async {
        final response = await index.search('An awesome');

        expect(response.hits[0], {
          "id": 5,
          "title": 'The Hobbit',
          "info": {
            "comment": 'An awesome book',
            "reviewNb": 900,
          },
        });
      });

      test(
          'searches on nested content with searchable on specific nested field',
          () async {
        await index.updateSearchableAttributes(
          ['title', 'info.comment'],
        ).waitFor(client: client);

        final response = await index.search('An awesome');

        expect(response.hits[0], {
          "id": 5,
          "title": 'The Hobbit',
          "info": {
            "comment": 'An awesome book',
            "reviewNb": 900,
          },
        });
      });

      test('searches on nested content with content with sort', () async {
        await index
            .updateSettings(
              IndexSettings(
                  searchableAttributes: ['title', 'info.comment'],
                  sortableAttributes: ['info.reviewNb']),
            )
            .waitFor(client: client);

        final response =
            await index.search('', SearchQuery(sort: ['info.reviewNb:desc']));

        expect(response.hits[0], {
          "id": 6,
          "title": 'Harry Potter and the Half-Blood Prince',
          "info": {
            "comment": 'The best book',
            "reviewNb": 1000,
          },
        });
      });
    });
  });
}
