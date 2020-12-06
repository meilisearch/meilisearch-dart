import 'package:meilisearch/meilisearch.dart';

final client = MeiliSearchClient('http://localhost:7700', 'masterKey');

Future<void> deleteAllIndexes() async {
  var indexes = await client.getIndexes();
  for (var item in indexes) {
    await item.delete();
  }
}

Future<void> setUpBasicIndex() async {
  //
}
