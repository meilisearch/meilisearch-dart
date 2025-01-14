import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/results/experimental_features.dart';
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

      test('Show ranking score details', () async {
        final res = await index
            .search(
              'The',
              SearchQuery(
                showRankingScore: true,
                showRankingScoreDetails: true,
                attributesToHighlight: ['*'],
                showMatchesPosition: true,
              ),
            )
            .asSearchResult()
            .mapToContainer();

        final attributeMatcher = isA<MeiliRankingScoreDetailsAttributeRule>()
            .having((p0) => p0.src, 'src', allOf(isNotNull, isNotEmpty))
            .having((p0) => p0.score, 'score', isNotNull)
            .having((p0) => p0.order, 'order', isNotNull)
            .having((p0) => p0.queryWordDistanceScore, 'queryWordDistanceScore',
                isNotNull)
            .having((p0) => p0.attributeRankingOrderScore,
                'attributeRankingOrderScore', isNotNull);

        final wordsMatcher = isA<MeiliRankingScoreDetailsWordsRule>()
            .having((p0) => p0.src, 'src', allOf(isNotNull, isNotEmpty))
            .having((p0) => p0.score, 'score', isNotNull)
            .having((p0) => p0.order, 'order', isNotNull)
            .having((p0) => p0.matchingWords, 'matchingWords', isNotNull)
            .having((p0) => p0.maxMatchingWords, 'maxMatchingWords', isNotNull);

        final exactnessMatcher = isA<MeiliRankingScoreDetailsExactnessRule>()
            .having((p0) => p0.src, 'src', allOf(isNotNull, isNotEmpty))
            .having((p0) => p0.score, 'score', isNotNull)
            .having((p0) => p0.order, 'order', isNotNull)
            .having(
              (p0) => p0.matchType,
              'matchType',
              allOf(isNotNull, isNotEmpty),
            );

        final typoMatcher = isA<MeiliRankingScoreDetailsTypoRule>()
            .having((p0) => p0.src, 'src', allOf(isNotNull, isNotEmpty))
            .having((p0) => p0.score, 'score', isNotNull)
            .having((p0) => p0.order, 'order', isNotNull)
            .having((p0) => p0.typoCount, 'typoCount', isNotNull)
            .having((p0) => p0.maxTypoCount, 'maxTypoCount', isNotNull);

        final proximityMatcher = isA<MeiliRankingScoreDetailsProximityRule>()
            .having((p0) => p0.src, 'src', allOf(isNotNull, isNotEmpty))
            .having((p0) => p0.score, 'score', isNotNull)
            .having((p0) => p0.order, 'order', isNotNull);

        final rankingScoreDetailsMatcher = isA<MeiliRankingScoreDetails>()
            .having((p0) => p0.src, 'src', allOf(isNotNull, isNotEmpty))
            .having((p0) => p0.attribute, 'attribute', attributeMatcher)
            .having((p0) => p0.words, 'words', wordsMatcher)
            .having((p0) => p0.exactness, 'exactness', exactnessMatcher)
            .having((p0) => p0.typo, 'typo', typoMatcher)
            .having((p0) => p0.proximity, 'proximity', proximityMatcher)
            .having((p0) => p0.customRules, 'customRules',
                allOf(isNotNull, isEmpty));

        expect(res.hits.length, 4);

        expect(
          res.hits,
          everyElement(
            isA<MeiliDocumentContainer<Map<String, dynamic>>>()
                .having(
                  (p0) => p0.parsed,
                  'parsed',
                  isNotEmpty,
                )
                .having(
                  (p0) => p0.src,
                  'src',
                  isNotEmpty,
                )
                .having(
                  (p0) => p0.rankingScore,
                  'rankingScore',
                  isNotNull,
                )
                .having(
                  (p0) => p0.rankingScoreDetails,
                  'rankingScoreDetails',
                  rankingScoreDetailsMatcher,
                ),
          ),
        );
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
      group('attributesToSearchOn', () {
        setUp(() async {
          await index.updateSearchableAttributes(
            ['title', 'info.comment'],
          ).waitFor(client: client);
        });

        test('empty result', () async {
          var response = await index.search(
            'An awesome',
            SearchQuery(attributesToSearchOn: ['title']),
          );

          expect(response.hits, isEmpty);
        });

        test('non-empty result', () async {
          var response = await index.search(
            'An awesome',
            SearchQuery(attributesToSearchOn: ['info.comment']),
          );

          expect(response.hits[0], {
            "id": 5,
            "title": 'The Hobbit',
            "info": {
              "comment": 'An awesome book',
              "reviewNb": 900,
            },
          });
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

  // Commented because of https://github.com/meilisearch/meilisearch-dart/issues/369
  group('Experimental', () {
    setUpClient();
    late String uid;
    late MeiliSearchIndex index;
    late ExperimentalFeatures features;
    setUp(() async {
      features = await client.http.updateExperimentalFeatures(
        UpdateExperimentalFeatures(
          vectorStore: true,
        ),
      );
      expect(features.vectorStore, true);

      uid = randomUid();
      index = await createIndexWithData(uid: uid, data: vectorBooks);
    });

    test('vector search', () async {
      final vector = [0, 1, 2];
      final res = await index
          .search(
            null,
            SearchQuery(
              vector: vector,
            ),
          )
          .asSearchResult()
          .mapToContainer();

      expect(res.vector, vector);
      expect(
        res.hits,
        everyElement(
          isA<MeiliDocumentContainer<Map<String, dynamic>>>()
              .having(
                (p0) => p0.vectors,
                'vectors',
                isNotNull,
              )
              .having(
                (p0) => p0.semanticScore,
                'semanticScore',
                isNotNull,
              ),
        ),
      );
    });
  }, skip: "Requires Experimental API");
  final openAiKeyValue = openAiKey;
  group('Embedders', () {
    group(
      'Unit test',
      () {
        // test serialization of models
        test(OpenAiEmbedder, () {
          final embedder = OpenAiEmbedder(
            model: 'text-embedding-3-small',
            apiKey: 'key',
            documentTemplate: 'a book titled {{ doc.title }}',
            binaryQuantized: true,
            dimensions: 100,
            distribution: DistributionShift(
              mean: 20,
              sigma: 5,
            ),
            url: 'https://example.com',
            documentTemplateMaxBytes: 200,
          );

          final map = embedder.toMap();

          expect(map, {
            'model': 'text-embedding-3-small',
            'apiKey': 'key',
            'documentTemplate': 'a book titled {{ doc.title }}',
            'dimensions': 100,
            'distribution': {
              'mean': 20,
              'sigma': 5,
            },
            'url': 'https://example.com',
            'documentTemplateMaxBytes': 200,
            'binaryQuantized': true,
            'source': 'openAi',
          });

          final deserialized = OpenAiEmbedder.fromMap(map);

          expect(deserialized.model, 'text-embedding-3-small');
          expect(deserialized.apiKey, 'key');
          expect(
              deserialized.documentTemplate, 'a book titled {{ doc.title }}');
          expect(deserialized.dimensions, 100);
          expect(deserialized.distribution?.mean, 20);
          expect(deserialized.distribution?.sigma, 5);
          expect(deserialized.url, 'https://example.com');
          expect(deserialized.documentTemplateMaxBytes, 200);
          expect(deserialized.binaryQuantized, true);
        });

        test(HuggingFaceEmbedder, () {});
      },
    );

    group(
      'Integration test',
      () {
        setUpClient();
        late String uid;
        late MeiliSearchIndex index;
        late IndexSettings settings;

        setUpAll(() {
          settings = IndexSettings(embedders: {
            'default': OpenAiEmbedder(
              model: 'text-embedding-3-small',
              apiKey: openAiKeyValue,
              documentTemplate: "a book titled '{{ doc.title }}'",
            ),
          });
        });

        setUp(() async {
          final features = await client.http.updateExperimentalFeatures(
              UpdateExperimentalFeatures(vectorStore: true));
          expect(features.vectorStore, true);
          uid = randomUid();
          index = await createBooksIndex(uid: uid);
        });

        test('set embedders', () async {
          final result =
              await index.updateSettings(settings).waitFor(client: client);

          expect(result.status, 'succeeded');
        });

        test('reset embedders', () async {
          final embedderResult =
              await index.resetEmbedders().waitFor(client: client);

          expect(embedderResult.status, 'succeeded');
        });

        test('hybrid search', () async {
          final settingsResult =
              await index.updateSettings(settings).waitFor(client: client);

          final sQuery = SearchQuery(
              hybrid: HybridSearch(embedder: 'default', semanticRatio: 0.9));

          final searchResult = await index.search('prince', sQuery);

          expect(settingsResult.status, 'succeeded');
          expect(searchResult.hits, hasLength(7));
        });
      },
      skip: openAiKeyValue == null || openAiKeyValue.isEmpty
          ? "Requires OPEN_AI_API_KEY environment variable"
          : null,
    );
  });

  test('search code samples', () async {
    // #docregion search_get_1
    await client.index('movies').search('American ninja');
    // #enddocregion

    // #docregion search_parameter_guide_show_ranking_score_1
    await client
        .index('movies')
        .search('dragon', SearchQuery(showRankingScore: true));
    // #enddocregion
  }, skip: true);

  test('facet search code samples', () async {
    // #docregion facet_search_1
    await client.index('books').facetSearch(
          FacetSearchQuery(
            facetQuery: 'fiction',
            facetName: 'genres',
            filter: 'rating > 3',
          ),
        );
    // #enddocregion

    // #docregion facet_search_2
    await client.index('books').updateFaceting(
          Faceting(
            sortFacetValuesBy: {
              'genres': FacetingSortTypes.count,
            },
          ),
        );
    // #enddocregion

    // #docregion facet_search_3
    await client.index('books').facetSearch(
          FacetSearchQuery(
            facetQuery: 'c',
            facetName: 'genres',
          ),
        );
    // #enddocregion

    // #docregion search_parameter_guide_attributes_to_search_on_1
    await client.index('books').facetSearch(
          FacetSearchQuery(
            facetQuery: 'c',
            facetName: 'genres',
          ),
        );
    // #enddocregion

    // #docregion search_parameter_guide_facet_stats_1
    await client
        .index('movie_ratings')
        .search('Batman', SearchQuery(facets: ['genres', 'rating']));
    // #enddocregion

    // #docregion faceted_search_1
    await client
        .index('books')
        .search('', SearchQuery(facets: ['genres', 'rating', 'language']));
    // #enddocregion

    // #docregion filtering_guide_nested_1
    await client.index('movie_ratings').search(
          'thriller',
          SearchQuery(
            filterExpression: Meili.gte(
              //or Meili.attr('rating.users')
              //or 'rating.users'.toMeiliAttribute()
              Meili.attrFromParts(['rating', 'users']),
              Meili.value(90),
            ),
          ),
        );
    // #enddocregion

    // #docregion sorting_guide_sort_nested_1
    await client
        .index('movie_ratings')
        .search('thriller', SearchQuery(sort: ['rating.users:asc']));
    // #enddocregion

    // #docregion search_parameter_guide_page_1
    await client
        .index('movies')
        .search('', SearchQuery(page: 2))
        .asPaginatedResult();
    // #enddocregion

    // #docregion search_parameter_guide_hitsperpage_1
    await client
        .index('movies')
        .search('', SearchQuery(hitsPerPage: 15))
        .asPaginatedResult();
    // #enddocregion
  }, skip: true);
}
