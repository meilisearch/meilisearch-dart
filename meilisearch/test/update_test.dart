import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/client.dart';

void main() {
  group('Update', () {
    setUpClient();

    test('Add documents and check an update have been processed', () async {
      var index = await client.createIndex(randomUid());
      await index.addDocuments(booksWithIntId).waitFor();
    });
  });
}
