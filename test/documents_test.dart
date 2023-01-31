import 'package:meilisearch/src/query_parameters/documents_query.dart';
import 'package:test/test.dart';
import 'package:meilisearch/src/exception.dart';

import 'utils/books_data.dart';
import 'utils/wait_for.dart';
import 'utils/client.dart';
import 'utils/books.dart';

void main() {
  group('Documents', () {
    setUpClient();

    test('Add documents', () async {
      final index = client.index(randomUid());
      await index.addDocuments(books).waitFor(client: client);
      final docs = await index.getDocuments();
      expect(docs.total, 6);
    });

    test('Add documents with primary key', () async {
      final index = client.index(randomUid());
      await index
          .addDocuments(books, primaryKey: 'book_id')
          .waitFor(client: client);
      final docs = await index.getDocuments();
      expect(docs.total, 6);
    });

    test('Update documents', () async {
      final index = await createBooksIndex();
      await index.updateDocuments([
        {'book_id': 1344, 'title': 'The Hobbit 2'},
      ]).waitFor(client: client);
      final doc = await index.getDocument(1344);
      expect(doc, isNotNull);
      expect(doc?['book_id'], equals(1344));
      expect(doc?['title'], equals('The Hobbit 2'));
    });

    test('Update documents and pass a primary key', () async {
      final uid = randomUid();
      var index = client.index(uid);
      await index.updateDocuments([
        {'the_book_id': 1344, 'title': 'The Hobbit 2'},
      ], primaryKey: 'the_book_id').waitFor(client: client);
      index = await client.getIndex(uid);
      expect(index.primaryKey, 'the_book_id');
      final doc = await index.getDocument(1344);
      expect(doc, isNotNull);
      expect(doc?['the_book_id'], equals(1344));
      expect(doc?['title'], equals('The Hobbit 2'));
    });

    test('Delete one document', () async {
      final index = await createBooksIndex();
      await index.deleteDocument(456).waitFor(client: client);
      expect(index.getDocument(456), throwsA(isA<MeiliSearchApiException>()));
    });

    test('Delete multiple documents', () async {
      final index = await createBooksIndex();
      await index.deleteDocuments([456, 4]).waitFor(client: client);
      expect(index.getDocument(4), throwsA(isA<MeiliSearchApiException>()));
      expect(index.getDocument(456), throwsA(isA<MeiliSearchApiException>()));
    });

    test('Delete all documents', () async {
      final index = await createBooksIndex();
      await index.deleteAllDocuments().waitFor(client: client);
      final docs = await index.getDocuments();
      expect(docs.total, 0);
    });

    test('Get documents with query params', () async {
      final index = await createBooksIndex();
      final docs = await index.getDocuments(
          params: DocumentsQuery(offset: 1, fields: ['book_id']));
      expect(docs.total, equals(6));
      expect(docs.offset, equals(1));
      expect(docs.limit, greaterThan(0));
      expect(docs.results[0]['book_id'], isNotNull);
      expect(docs.results[0]['title'], isNull);
    });

    test('Get document with fields', () async {
      final index = await createBooksIndex();
      final doc = await index.getDocument(1, fields: ['book_id']);

      expect(doc?['book_id'], isNotNull);
      expect(doc?['title'], isNull);
    });
  });
}
