import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/client.dart';

void main() {
  group('Documents', () {
    setUpClient();

    test('Add documents', () async {
      var index = await client.createIndex(randomUid());
      await index.addDocuments(booksDoc);
    });

    test('Add documents', () async {
      var index = await client.createIndex(randomUid());
      await index.addDocuments(booksDoc, primaryKey: 'book_id');
    });

    test('Update documents', () async {
      var index = await createBooksIndex();
      await index.updateDocuments([
        {'book_id': 1344, 'title': 'The Hobbit'},
      ]).waitFor();
    });

    test('Update documents and pass a primary key', () async {
      var index = await client.createIndex(randomUid());
      await index.updateDocuments([
        {'the_book_id': 1344, 'title': 'The Hobbit'},
      ], primaryKey: 'the_book_id').waitFor();
    });

    test('Delete one document', () async {
      var index = await createBooksIndex();
      await index.deleteDocument(456).waitFor();
      expect(index.getDocument(456), throwsException);
    });

    test('Delete multiple documents', () async {
      var index = await createBooksIndex();
      await index.deleteDocuments([456, 4]).waitFor();
      expect(index.getDocument(4), throwsException);
      expect(index.getDocument(456), throwsException);
    });

    test('Delete all documents', () async {
      var index = await createBooksIndex();
      await index.deleteAllDocuments().waitFor();
      var docs = await index.getDocuments();
      expect(docs, isEmpty);
    });
  });
}
