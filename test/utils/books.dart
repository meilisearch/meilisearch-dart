import 'package:meilisearch/meilisearch.dart';

import 'books_data.dart';
import 'client.dart';
import 'wait_for.dart';

Future<MeiliSearchIndex> createDynamicBooksIndex({
  String? uid,
  required int count,
}) {
  return createIndexWithData(
    uid: uid,
    data: dynamicBooks(count),
  );
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
}) {
  return createIndexWithData(
    uid: uid,
    data: isNested ? nestedBooks : books,
  );
}

Future<MeiliSearchIndex> createIndexWithData({
  String? uid,
  required List<Map<String, dynamic>> data,
}) async {
  final index = client.index(uid ?? randomUid());
  final response = await index.addDocuments(data).waitFor(client: client);

  if (response.status != 'succeeded') {
    throw Exception(
      'Impossible to process test suite, the documents were not added into the index.',
    );
  }
  return index;
}

class BookDto {
  final int bookId;
  final String title;
  final String? tag;

  const BookDto({
    required this.bookId,
    required this.title,
    required this.tag,
  });

  Map<String, dynamic> toMap() {
    return {
      kbookId: bookId,
      ktitle: title,
      ktag: tag,
    };
  }

  factory BookDto.fromMap(Map<String, dynamic> map) {
    return BookDto(
      bookId: map[kbookId] as int,
      title: map[ktitle] as String,
      tag: map[ktag] as String?,
    );
  }
}
