import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/client.dart';

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
      expect(result.hits, hasLength(booksDoc.length));
    });

    test('with basic query with an empty string q=""', () async {
      var index = await createBooksIndex();
      var result = await index.search('');
      expect(result.hits, hasLength(booksDoc.length));
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
    });
  });
}
