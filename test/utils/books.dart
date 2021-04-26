import 'package:meilisearch/meilisearch.dart';

import 'client.dart';

var booksDoc = [
  {'book_id': 123, 'title': 'Pride and Prejudice'},
  {'book_id': 456, 'title': 'Le Petit Prince'},
  {'book_id': 1, 'title': 'Alice In Wonderland'},
  {'book_id': 1344, 'title': 'The Hobbit'},
  {'book_id': 4, 'title': 'Harry Potter and the Half-Blood Prince'},
  {'book_id': 42, 'title': 'The Hitchhiker\'s Guide to the Galaxy'}
];

Future<MeiliSearchIndex> createBooksIndex() async {
  final index = await client.createIndex(randomUid());
  final response = await index.addDocuments(booksDoc).waitFor();
  if (response.status != 'processed') {
    throw Exception(
        'Impossible to process test suite, the documents were not added into the index.');
  }
  return index;
}
