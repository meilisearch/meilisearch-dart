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

var nestedBooksDoc = [
  {
    "id": 1,
    "title": 'Pride and Prejudice',
    "info": {
      "comment": 'A great book',
      "reviewNb": 500,
    },
  },
  {
    "id": 2,
    "title": 'Le Petit Prince',
    "info": {
      "comment": 'A french book',
      "reviewNb": 600,
    },
  },
  {
    "id": 3,
    "title": 'Le Rouge et le Noir',
    "info": {
      "comment": 'Another french book',
      "reviewNb": 700,
    },
  },
  {
    "id": 4,
    "title": 'Alice In Wonderland',
    "comment": 'A weird book',
    "info": {
      "comment": 'A weird book',
      "reviewNb": 800,
    },
  },
  {
    "id": 5,
    "title": 'The Hobbit',
    "info": {
      "comment": 'An awesome book',
      "reviewNb": 900,
    },
  },
  {
    "id": 6,
    "title": 'Harry Potter and the Half-Blood Prince',
    "info": {
      "comment": 'The best book',
      "reviewNb": 1000,
    },
  },
  {"id": 7, "title": "The Hitchhiker's Guide to the Galaxy"},
];

Future<MeiliSearchIndex> createBooksIndex({String? uid}) async {
  return _createIndex(uid: uid);
}

Future<MeiliSearchIndex> createNestedBooksIndex({String? uid}) async {
  return _createIndex(uid: uid, isNested: true);
}

Future<MeiliSearchIndex> _createIndex(
    {String? uid, bool isNested = false}) async {
  final index = client.index(uid ?? randomUid());
  final books = isNested ? nestedBooksDoc : booksDoc;
  final response = await index.addDocuments(books).waitFor();

  if (response.status != 'succeeded') {
    throw Exception(
        'Impossible to process test suite, the documents were not added into the index.');
  }
  return index;
}
