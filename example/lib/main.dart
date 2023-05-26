import 'package:meilisearch/meilisearch.dart';

void main() async {
  var client = MeiliSearchClient('http://127.0.0.1:7700', 'masterKey');

  // An index where books are stored.
  await client.createIndex('books');
  var index = await client.getIndex('books');

  var documents = [
    {'book_id': 123, 'title': 'Pride and Prejudice'},
    {'book_id': 456, 'title': 'Le Petit Prince'},
    {'book_id': 1, 'title': 'Alice In Wonderland'},
    {'book_id': 1344, 'title': 'The Hobbit'},
    {'book_id': 4, 'title': 'Harry Potter and the Half-Blood Prince'},
    {'book_id': 42, 'title': 'The Hitchhiker\'s Guide to the Galaxy'}
  ];

  // Add documents into index we just created.
  await index.addDocuments(documents);

  // Search
  var result = await index.search('prience');
  print(result.hits);
}
