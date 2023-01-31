import 'package:meilisearch/src/swap_index.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Swaps indexes', () {
    setUpClient();

    test('swaps indexes from input', () async {
      var books = ['books', 'books_new'];
      var movies = ['movies', 'movies_new'];
      var swaps = [SwapIndex(books), SwapIndex(movies)];

      var response = await client.swapIndexes(swaps).waitFor();

      expect(response.type, 'indexSwap');
      expect(response.details!['swaps'], [
        {'indexes': books},
        {'indexes': movies}
      ]);
    });
  });
}
