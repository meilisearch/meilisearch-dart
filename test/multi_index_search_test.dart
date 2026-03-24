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
      expect(result.results.first.indexUid, index1.uid);
      expect(result.results.first.hits.length, 1);
      //test second result
      expect(result.results.last.indexUid, index2.uid);
      expect(result.results.last.hits.length, 2);
    });
  });

  group("Federated search with distinct", () {
    setUpClient();
    late MeiliSearchIndex index1;
    late MeiliSearchIndex index2;

    setUp(() async {
      index1 = client.index(randomUid());
      index2 = client.index(randomUid());

      await Future.wait([
        index1
            .updateDistinctAttribute(ktag)
            .then((task) => task.waitFor(client: client)),
        index2
            .updateDistinctAttribute(ktag)
            .then((task) => task.waitFor(client: client)),
        index1.addDocuments(books).waitFor(client: client),
        index2.addDocuments(books).waitFor(client: client),
      ]);
    });

    test("Federated search with distinct parameter", () async {
      final result = await client.multiSearch(MultiSearchQuery(
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
        federation: FederationOptions(
          distinct: ktag,
        ),
      ));

      // When using federation, results are merged
      expect(result.results, isNotEmpty);
    });

    test("Federated search without distinct parameter", () async {
      final result = await client.multiSearch(MultiSearchQuery(
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
        federation: FederationOptions(),
      ));

      expect(result.results, isNotEmpty);
    });
  });

  group("MultiSearchQuery serialization", () {
    test("serializes federation.distinct when set", () {
      final query = MultiSearchQuery(
        queries: [IndexSearchQuery(indexUid: 'movies')],
        federation: FederationOptions(distinct: ktag),
      );
      final map = query.toSparseMap();
      expect(map['federation'], isA<Map<String, Object>>());
      final federation = map['federation'] as Map<String, Object>;
      expect(federation['distinct'], equals(ktag));
    });

    test("omits federation.distinct when not set", () {
      final query = MultiSearchQuery(
        queries: [IndexSearchQuery(indexUid: 'movies')],
        federation: FederationOptions(),
      );
      final map = query.toSparseMap();
      expect(map['federation'], isA<Map<String, Object>>());
      final federation = map['federation'] as Map<String, Object>;
      expect(federation.containsKey('distinct'), isFalse);
    });

    test("omits federation when not provided", () {
      final query = MultiSearchQuery(
        queries: [IndexSearchQuery(indexUid: 'movies')],
      );
      final map = query.toSparseMap();
      expect(map.containsKey('federation'), isFalse);
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

  test('federated search with distinct code sample', () async {
    // #docregion federated_search_distinct
    await client.multiSearch(MultiSearchQuery(
      queries: [
        IndexSearchQuery(query: 'pooh', indexUid: 'movies'),
        IndexSearchQuery(query: 'pooh', indexUid: 'books'),
      ],
      federation: FederationOptions(
        distinct: 'title',
      ),
    ));
    // #enddocregion
  }, skip: true);
}
