import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/books_data.dart';
import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group("MultiIndex search", () {
    setUpClient();
    late MeiliSearchIndex index1;
    late MeiliSearchIndex index2;

    setUp(() async {
      index1 = client.index(randomUid());
      index2 = client.index(randomUid());

      await Future.wait([
        index1.updateFilterableAttributes([ktag]).waitFor(client: client),
        index2.updateFilterableAttributes([ktag]).waitFor(client: client),
        index1.addDocuments(books).waitFor(client: client),
        index2.addDocuments(books).waitFor(client: client),
      ]);
    });

    test("Multi search from 2 indexes", () async {
      final result = await client.multiSearch(MultiSearchQuery(queries: [
        IndexSearchQuery(
          query: "",
          indexUid: index1.uid,
          filterExpression:
              ktag.toMeiliAttribute().eq("Romance".toMeiliValue()),
        ),
        IndexSearchQuery(
          indexUid: index2.uid,
          filterExpression: ktag.toMeiliAttribute().eq("Tale".toMeiliValue()),
        ),
      ]));

      expect(result.results, hasLength(2));
      //test first result
      expect(result.results!.first.indexUid, index1.uid);
      expect(result.results!.first.hits.length, 1);
      //test second result
      expect(result.results!.last.indexUid, index2.uid);
      expect(result.results!.last.hits.length, 2);
    });
  });

  group("Federated search", () {
    setUpClient();
    late MeiliSearchIndex index1;
    late MeiliSearchIndex index2;

    setUp(() async {
      index1 = client.index(randomUid());
      index2 = client.index(randomUid());

      await Future.wait([
        index1.updateFilterableAttributes([ktag]).waitFor(client: client),
        index2.updateFilterableAttributes([ktag]).waitFor(client: client),
        index1.addDocuments(books).waitFor(client: client),
        index2.addDocuments(books).waitFor(client: client),
      ]);
    });

    test("Federated search with empty federation object", () async {
      final result = await client.multiSearch(MultiSearchQuery(
        federation: Federation(),
        queries: [
          IndexSearchQuery(
            query: "Prince",
            indexUid: index1.uid,
          ),
          IndexSearchQuery(
            query: "Prince",
            indexUid: index2.uid,
          ),
        ],
      ));

      expect(result.federated, isNotNull);
      expect(result.results, isNull);

      final federated = result.federated!;
      expect(federated.hits, isNotEmpty);
      // Each hit should have _federation metadata
      for (final hit in federated.hits) {
        expect(hit['_federation'], isNotNull);
        final federation = hit['_federation'] as Map<String, dynamic>;
        expect(federation['indexUid'], isNotNull);
        expect(federation['queriesPosition'], isNotNull);
      }
    });

    test("Federated search with weight", () async {
      final result = await client.multiSearch(MultiSearchQuery(
        federation: Federation(),
        queries: [
          IndexSearchQuery(
            query: "Prince",
            indexUid: index1.uid,
            federationOptions: FederationOptions(weight: 0.1),
          ),
          IndexSearchQuery(
            query: "Prince",
            indexUid: index2.uid,
            federationOptions: FederationOptions(weight: 10.0),
          ),
        ],
      ));

      expect(result.federated, isNotNull);
      final federated = result.federated!;
      expect(federated.hits, isNotEmpty);

      // With a much higher weight on index2, its results should
      // appear before index1's results.
      final firstHit = federated.hits.first;
      final firstFederation = firstHit['_federation'] as Map<String, dynamic>;
      expect(firstFederation['indexUid'], index2.uid);
    });

    test("Federated search with limit and offset", () async {
      final result = await client.multiSearch(MultiSearchQuery(
        federation: Federation(limit: 2, offset: 0),
        queries: [
          IndexSearchQuery(
            query: "",
            indexUid: index1.uid,
          ),
          IndexSearchQuery(
            query: "",
            indexUid: index2.uid,
          ),
        ],
      ));

      expect(result.federated, isNotNull);
      final federated = result.federated!;
      expect(federated.hits.length, lessThanOrEqualTo(2));
      expect(federated.limit, 2);
      expect(federated.offset, 0);
      expect(federated.estimatedTotalHits, isNotNull);
    });

    test("Federated search result has processingTimeMs", () async {
      final result = await client.multiSearch(MultiSearchQuery(
        federation: Federation(),
        queries: [
          IndexSearchQuery(
            query: "Hobbit",
            indexUid: index1.uid,
          ),
        ],
      ));

      expect(result.federated, isNotNull);
      expect(result.federated!.processingTimeMs, isNotNull);
    });
  });

  test('code samples', () async {
    // #docregion multi_search_1
    await client.multiSearch(MultiSearchQuery(queries: [
      IndexSearchQuery(query: 'pooh', indexUid: 'movies', limit: 5),
      IndexSearchQuery(query: 'nemo', indexUid: 'movies', limit: 5),
      IndexSearchQuery(query: 'us', indexUid: 'movies_ratings'),
    ]));
    // #enddocregion
  }, skip: true);

  test('code samples federated', () async {
    // #docregion federated_multi_search_1
    await client.multiSearch(MultiSearchQuery(
      federation: Federation(),
      queries: [
        IndexSearchQuery(query: 'batman', indexUid: 'movies'),
        IndexSearchQuery(query: 'batman', indexUid: 'comics'),
      ],
    ));
    // #enddocregion
  }, skip: true);

  test('code samples federated with weight', () async {
    // #docregion federated_multi_search_weight
    await client.multiSearch(MultiSearchQuery(
      federation: Federation(),
      queries: [
        IndexSearchQuery(query: 'batman', indexUid: 'movies'),
        IndexSearchQuery(
          query: 'batman',
          indexUid: 'comics',
          federationOptions: FederationOptions(weight: 1.2),
        ),
      ],
    ));
    // #enddocregion
  }, skip: true);
}
