import 'package:meilisearch/meilisearch.dart';

import 'client.dart';

var booksDoc = [
  {'book_id': 123, 'title': 'Pride and Prejudice', 'tag': 'Romance'},
  {'book_id': 456, 'title': 'Le Petit Prince', 'tag': 'Tale'},
  {'book_id': 1, 'title': 'Alice In Wonderland', 'tag': 'Tale'},
  {'book_id': 1344, 'title': 'The Hobbit', 'tag': 'Epic fantasy'},
  {
    'book_id': 4,
    'title': 'Harry Potter and the Half-Blood Prince',
    'tag': 'Epic fantasy'
  },
  {
    'book_id': 42,
    'title': 'The Hitchhiker\'s Guide to the Galaxy',
    'tag': 'Epic fantasy'
  }
];

Future<MeiliSearchIndex> createBooksIndex({String? uid}) async {
  final index = client.index(uid ?? randomUid());
  final response = await index.addDocuments(booksDoc).waitFor();
  if (response.status != 'succeeded') {
    throw Exception(
        'Impossible to process test suite, the documents were not added into the index.');
  }
  return index;
}
