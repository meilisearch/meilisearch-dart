import 'package:meilisearch/src/key.dart';
import 'package:meilisearch/src/query_parameters/indexes_query.dart';
import 'package:meilisearch/src/query_parameters/keys_query.dart';
import 'package:meilisearch/src/query_parameters/tasks_query.dart';
import 'package:meilisearch/src/result.dart';
import 'package:meilisearch/src/result_task.dart';
import 'package:meilisearch/src/task.dart';

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

  String generateTenantToken(dynamic searchRules, String uid,
      {DateTime? expiresAt});

  /// Create an index object by given [uid].
  MeiliSearchIndex index(String uid);

  /// Return list of all existing indexes.
  Future<Result<MeiliSearchIndex>> getIndexes({IndexesQuery? params});

  /// Find index by matching [uid]. Throws error if index is not exists.
  Future<MeiliSearchIndex> getIndex(String uid);

  /// Find index by matching [uid] and responds with raw information from API.
  /// Throws error if index is not exists.
  Future<Map<String, dynamic>> getRawIndex(String uid);

  /// Create a new index by given [uid] and optional [primaryKey] parameter.
  /// Throws an error if index is already exists.
  Future<Task> createIndex(String uid, {String primaryKey});

  /// Delete the index by matching [uid].
  Future<Task> deleteIndex(String uid);

  /// Update the primary Key of the index by matching [uid].
  Future<Task> updateIndex(String uid, String primaryKey);

  /// Return health of the Meilisearch server.
  /// Throws an error if containing details if Meilisearch can't process your request.
  Future<Map<String, dynamic>> health();

  /// Get health of the Meilisearch server.
  /// Return true or false.
  Future<bool> isHealthy();

  /// Trigger a dump creation process.
  Future<Task> createDump();

  /// Get the public and private keys.
  Future<Result<Key>> getKeys({KeysQuery? params});

  /// Get a specific key by key or uid.
  Future<Key> getKey(String keyOrUid);

  /// Create a new key.
  Future<Key> createKey(
      {DateTime? expiresAt,
      String? description,
      String? uid,
      required List<String> indexes,
      required List<String> actions});

  /// Update a key.
  Future<Key> updateKey(String key, {String? description, String? name});

  /// Delete a key
  Future<bool> deleteKey(String key);

  /// Get the Meilisearch version
  Future<Map<String, String>> getVersion();

  /// Get all index stats.
  Future<AllStats> getStats();

  /// Get a list of tasks from the client.
  Future<ResultTask> getTasks({TasksQuery? params});

  /// Get a task from an index specified by uid with the specified uid.
  Future<Task> getTask(int uid);
}
