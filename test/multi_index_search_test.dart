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

    test("Multi search with showPerformanceDetails", () async {
      final result = await client.multiSearch(MultiSearchQuery(queries: [
        IndexSearchQuery(
          query: "prince",
          indexUid: index1.uid,
          showPerformanceDetails: true,
        ),
        IndexSearchQuery(
          query: "hobbit",
          indexUid: index2.uid,
          showPerformanceDetails: true,
        ),
      ]));

      expect(result.results, hasLength(2));
      expect(result.results.first.performanceDetails, isNotNull);
      expect(
          result.results.first.performanceDetails, isA<Map<String, dynamic>>());
      expect(result.results.last.performanceDetails, isNotNull);
      expect(
          result.results.last.performanceDetails, isA<Map<String, dynamic>>());
    });

    test("Multi search performanceDetails is null when not requested",
        () async {
      final result = await client.multiSearch(MultiSearchQuery(queries: [
        IndexSearchQuery(
          query: "prince",
          indexUid: index1.uid,
        ),
      ]));

      expect(result.results.first.performanceDetails, isNull);
    });

    test("Multi search performanceDetails is null when set to false", () async {
      final result = await client.multiSearch(MultiSearchQuery(queries: [
        IndexSearchQuery(
          query: "prince",
          indexUid: index1.uid,
          showPerformanceDetails: false,
        ),
      ]));

      expect(result.results.first.performanceDetails, isNull);
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
}
