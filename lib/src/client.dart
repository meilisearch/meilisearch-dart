import 'index.dart';
import 'client_impl.dart';

abstract class MeiliSearchClient {
  factory MeiliSearchClient(String serverUrl, [String apiKey]) =
      MeiliSearchClientImpl;

  /// MeiliSearch server URL.
  final String serverUrl;

  /// Master key for authenticating with meilisearch server.
  final String apiKey;

  /// Returns list of all exists indexes.
  Future<List<MeiliSearchIndex>> getIndexes();

  /// Finds index by matching [uid]. Throws error if index is not exists.
  Future<MeiliSearchIndex> getIndex(String uid);

  /// Creates a new index by given [uid] and optional [primaryKey] parameter.
  /// Throws an error if index is already exists.
  Future<MeiliSearchIndex> createIndex(String uid, {String primaryKey});

  /// Finds index by matching [uid]. If index is not exists tries to create a
  /// new index.
  Future<MeiliSearchIndex> getOrCreateIndex(String uid, {String primaryKey});

  /// Return health of the MeiliSearch server.
  /// Throws an error if containing details if MeiliSearch can't process your request.
  Future<Map<String, dynamic>> health();

  /// Get health of the MeiliSearch server.
  /// Return true or false.
  Future<bool> isHealthy();
}
