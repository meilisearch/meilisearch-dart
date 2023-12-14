import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';
import 'utils/wait_for.dart';

void main() {
  group('Swaps indexes', () {
    setUpClient();

    test('swaps indexes from input', () async {
      var books = ['books', 'books_new'];
      var movies = ['movies', 'movies_new'];
      var swaps = [SwapIndex(books), SwapIndex(movies)];

      var response = await client
          .swapIndexes(
            swaps,
            deleteWhenDone: false,
          )
          .waitFor(
            client: client,
            throwFailed: false,
          );

      expect(response.type, 'indexSwap');
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
