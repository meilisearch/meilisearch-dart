import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Swaps indexes', () {
    setUpClient();

    test('swaps indexes from input', () async {
      var books = [randomUid('books'), randomUid('books_new')];
      var movies = [randomUid('movies'), randomUid('movies_new')];
      var swaps = [SwapIndex(books), SwapIndex(movies)];

      // first create the indexes to be swapped
      for (var index in books + movies) {
        await client.createIndex(index).waitFor(client: client);
      }

      var response = await client
          .swapIndexes(
            swaps,
            deleteWhenDone: false,
          )
          .waitFor(
            client: client,
            throwFailed: true,
          );

      expect(response.type, 'indexSwap');
      expect(response.error, null);
      expect(response.status, 'succeeded');
      expect(response.details!['swaps'], [
        {'indexes': books},
        {'indexes': movies}
      ]);
    });
  });

  test('code samples', () async {
    // #docregion swap_indexes_1
    await client.swapIndexes([
      SwapIndex(['indexA', 'indexB']),
      SwapIndex(['indexX', 'indexY']),
    ]);
    // #enddocregion
  }, skip: true);
}
