import 'package:meilisearch/meilisearch.dart';

import 'books_data.dart';
import 'client.dart';
import 'wait_for.dart';



Future<MeiliSearchIndex> createDynamicBooksIndex({
  String? uid,
  required int count,
}) async {
  final index = client.index(uid ?? randomUid());
  final docs = dynamicBooks(count);
  final response = await index.addDocuments(docs).waitFor(client: client);

  if (response.status != 'succeeded') {
    throw Exception(
        'Impossible to process test suite, the documents were not added into the index.');
  }
  return index;
}

Future<MeiliSearchIndex> createBooksIndex({String? uid}) async {
  return _createIndex(uid: uid);
}

Future<MeiliSearchIndex> createNestedBooksIndex({String? uid}) async {
  return _createIndex(uid: uid, isNested: true);
}

Future<MeiliSearchIndex> _createIndex({
  String? uid,
  bool isNested = false,
}) async {
  final index = client.index(uid ?? randomUid());
  final docs = isNested ? nestedBooks : books;
  final response = await index.addDocuments(docs).waitFor(client: client);

  if (response.status != 'succeeded') {
    throw Exception(
        'Impossible to process test suite, the documents were not added into the index.');
  }
  return index;
}
