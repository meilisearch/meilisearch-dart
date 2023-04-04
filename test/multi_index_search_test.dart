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
        SearchQuery(
          query: "",
          indexUid: index1.uid,
          filterExpression:
              ktag.toMeiliAttribute().eq("Romance".toMeiliValue()),
        ),
        SearchQuery(
          query: "",
          indexUid: index2.uid,
          filterExpression: ktag.toMeiliAttribute().eq("Tale".toMeiliValue()),
        ),
      ]));

      expect(result.results, hasLength(2));
      //test first result
      expect(result.results.first.indexUid, index1.uid);
      expect(result.results.first.hits!.length, 1);
      //test second result
      expect(result.results.last.indexUid, index2.uid);
      expect(result.results.last.hits!.length, 2);
    });
  });
}
