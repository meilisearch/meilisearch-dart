import 'package:meilisearch/src/key.dart';
import 'package:meilisearch/src/task.dart';
import 'package:meilisearch/src/task_info.dart';

import 'http_request.dart';
import 'index.dart';
import 'client_impl.dart';
import 'stats.dart' show AllStats;

abstract class MeiliSearchClient {
  factory MeiliSearchClient(String serverUrl,
      [String? apiKey, int? connectTimeout]) = MeiliSearchClientImpl;

  /// Http client instance.
  HttpRequest get http;

  /// Meilisearch server URL.
  String get serverUrl;

  /// Master key for authenticating with meilisearch server.
  String? get apiKey;

  /// Timeout in milliseconds for opening a url.
  int? get connectTimeout;

  String generateTenantToken(dynamic searchRules,
      {String? apiKey, DateTime? expiresAt});

  /// Create an index object by given [uid].
  MeiliSearchIndex index(String uid);

  /// Return list of all existing indexes.
  Future<List<MeiliSearchIndex>> getIndexes();

  /// Find index by matching [uid]. Throws error if index is not exists.
  Future<MeiliSearchIndex> getIndex(String uid);

  /// Find index by matching [uid] and responds with raw information from API.
  /// Throws error if index is not exists.
  Future<Map<String, dynamic>> getRawIndex(String uid);

  /// Create a new index by given [uid] and optional [primaryKey] parameter.
  /// Throws an error if index is already exists.
  Future<TaskInfo> createIndex(String uid, {String primaryKey});

  /// Delete the index by matching [uid].
  Future<TaskInfo> deleteIndex(String uid);

  /// Update the primary Key of the index by matching [uid].
  Future<TaskInfo> updateIndex(String uid, String primaryKey);

  /// Return health of the Meilisearch server.
  /// Throws an error if containing details if Meilisearch can't process your request.
  Future<Map<String, dynamic>> health();

  /// Get health of the Meilisearch server.
  /// Return true or false.
  Future<bool> isHealthy();

  /// Trigger a dump creation process.
  Future<Map<String, String>> createDump();

  /// Get the status of a dump creation process.
  Future<Map<String, String>> getDumpStatus(String uid);

  /// Get the public and private keys.
  Future<List<Key>> getKeys();

  /// Get a specific key by key.
  Future<Key> getKey(String key);

  /// Create a new key.
  Future<Key> createKey(
      {DateTime? expiresAt,
      String? description,
      required List<String> indexes,
      required List<String> actions});

  /// Update a key.
  Future<Key> updateKey(String key,
      {DateTime? expiresAt,
      String? description,
      List<String>? indexes,
      List<String>? actions});

  /// Delete a key
  Future<bool> deleteKey(String key);

  /// Get the Meilisearch version
  Future<Map<String, String>> getVersion();

  /// Get all index stats.
  Future<AllStats> getStats();

  /// Get a list of tasks from the client.
  Future<List<Task>> getTasks();

  /// Get a task from an index specified by uid with the specified uid.
  Future<Task> getTask(int uid);
}
