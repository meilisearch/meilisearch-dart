import 'index.dart';
import 'client_impl.dart';

abstract class MeiliSearchClient {
  factory MeiliSearchClient(String serverUrl, [String masterKey]) =
      MeiliSearchClientImpl;

  /// MeiliSearch server URL.
  final String serverUrl;

  /// Master key for authenticating with meilisearch server.
  final String masterKey;

  Future<List<MeiliSearchIndex>> getIndexes();
  Future<MeiliSearchIndex> getIndex(String uid);
  Future<MeiliSearchIndex> createIndex(String uid, {String primaryKey});
}
