import 'package:test/test.dart';
import 'package:meilisearch/src/exception.dart';

import 'utils/books.dart';
import 'utils/client.dart';

void main() {
  group('Documents', () {
    setUpClient();

    test('Add documents', () async {
      var index = client.index(randomUid());
      final response = await index.addDocuments(booksDoc).waitFor();
      expect(response.status, 'succeeded');
      final docs = await index.getDocuments();
      expect(docs.length, 6);
    });

    test('Add documents with primary key', () async {
      final index = client.index(randomUid());
      final response =
          await index.addDocuments(booksDoc, primaryKey: 'book_id').waitFor();
      expect(response.status, 'succeeded');
      final docs = await index.getDocuments();
      expect(docs.length, 6);
    });

    test('Update documents', () async {
      final index = await createBooksIndex();
      final response = await index.updateDocuments([
        {'book_id': 1344, 'title': 'The Hobbit 2'},
      ]).waitFor();
      expect(response.status, 'succeeded');
      final doc = await index.getDocument(1344);
      expect(doc, isNotNull);
      expect(doc?['book_id'], 1344);
      expect(doc?['title'], 'The Hobbit 2');
    });

    test('Update documents and pass a primary key', () async {
      final uid = randomUid();
      var index = client.index(uid);
      final response = await index.updateDocuments([
        {'the_book_id': 1344, 'title': 'The Hobbit 2'},
      ], primaryKey: 'the_book_id').waitFor();
      expect(response.status, 'succeeded');
      index = await client.getIndex(uid);
      expect(index.primaryKey, 'the_book_id');
      final doc = await index.getDocument(1344);
      expect(doc, isNotNull);
      expect(doc?['the_book_id'], 1344);
      expect(doc?['title'], 'The Hobbit 2');
    });

    test('Delete one document', () async {
      final index = await createBooksIndex();
      final response = await index.deleteDocument(456).waitFor();
      expect(response.status, 'succeeded');
      expect(index.getDocument(456), throwsA(isA<MeiliSearchApiException>()));
    });

    test('Delete multiple documents', () async {
      final index = await createBooksIndex();
      final response = await index.deleteDocuments([456, 4]).waitFor();
      expect(response.status, 'succeeded');
      expect(index.getDocument(4), throwsA(isA<MeiliSearchApiException>()));
      expect(index.getDocument(456), throwsA(isA<MeiliSearchApiException>()));
    });

    test('Delete all documents', () async {
      final index = await createBooksIndex();
      final response = await index.deleteAllDocuments().waitFor();
      expect(response.status, 'succeeded');
      final docs = await index.getDocuments();
      expect(docs, isEmpty);
    });

    test('Get documents with query params', () async {
      final index = await createBooksIndex();
      final docs = await index.getDocuments(
        offset: 1,
        limit: 2,
        attributesToRetrieve: 'book_id',
      );
      expect(docs.length, 2);
      expect(docs[0]['book_id'], isNotNull);
      expect(docs[0]['title'], null);
    });
  });
}
