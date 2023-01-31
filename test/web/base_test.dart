import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';
import '../utils/books_data.dart';
import '../utils/wait_for.dart';

final client = MeiliSearchClient(serverUrl, 'masterKey', 1000);
String serverUrl = 'http://localhost:7700';

Future<MeiliSearchIndex> _createIndex({String? uid}) async {
  final index = client.index(uid ?? 'index');
  final response = await index.addDocuments(books).waitFor(client: client);

  if (response.status != 'succeeded') {
    throw Exception('Error: The documents were not added into the index.');
  }

  return index;
}

void main() {
  group('Search', () {
    test('with basic query', () async {
      var index = await _createIndex();
      var result = await index.search('prience'); // with typo

      expect(result.hits, hasLength(2));
    });
  });
}
