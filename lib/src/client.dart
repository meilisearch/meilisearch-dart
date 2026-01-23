import 'package:meilisearch/meilisearch.dart';
import 'package:dio/dio.dart';
import 'annotations.dart';
import 'tenant_token.dart';
import 'http_request.dart';

class MeiliSearchClient {
  MeiliSearchClient(
    this.serverUrl, [
    this.apiKey,
    this.connectTimeout,
    HttpClientAdapter? adapter,
    List<Interceptor>? interceptors,
  ]) : http = HttpRequest(
          serverUrl,
          apiKey,
          connectTimeout,
          adapter,
          interceptors,
        );

  factory MeiliSearchClient.withCustomDio(
    String serverUrl, {
    String? apiKey,
    Duration? connectTimeout,
    HttpClientAdapter? adapter,
    List<Interceptor>? interceptors,
  }) =>
      MeiliSearchClient(
        serverUrl,
        apiKey,
        connectTimeout,
        adapter,
        interceptors,
      );

  /// Meilisearch server URL.
  final String serverUrl;

  /// Master key for authenticating with meilisearch server.
  final String? apiKey;

  /// Timeout in milliseconds for opening a url.
  final Duration? connectTimeout;

  /// Http client instance.
  final HttpRequest http;

  /// Create an index object by given [uid].
  MeiliSearchIndex index(String uid) {
    return MeiliSearchIndex(this, uid);
  }

  Future<Task> _update(Future<Response<Map<String, Object?>>> future) async {
    final response = await future;

    return Task.fromMap(response.data!);
  }

  /// Create a new index by given [uid] and optional [primaryKey] parameter.
  /// Throws an error if index is already exists.
  Future<Task> createIndex(String uid, {String? primaryKey}) async {
    final data = <String, Object?>{
      'uid': uid,
      if (primaryKey != null) 'primaryKey': primaryKey,
    };

    return await _update(
        http.postMethod<Map<String, Object?>>('/indexes', data: data));
  }

  /// Find index by matching [uid]. Throws error if index is not exists.
  Future<MeiliSearchIndex> getIndex(String uid) async {
    final response = await _getIndex(uid);

    return MeiliSearchIndex.fromMap(this, response.data!);
  }

  /// Find index by matching [uid] and responds with raw information from API.
  /// Throws error if index does not exist.
  Future<Map<String, Object?>> getRawIndex(String uid) async {
    final response = await _getIndex(uid);

    return response.data!;
  }

  Future<Response<Map<String, Object?>>> _getIndex(String uid) {
    return http.getMethod<Map<String, dynamic>>('/indexes/$uid');
  }

  /// Return list of all existing indexes.
  Future<Result<MeiliSearchIndex>> getIndexes({IndexesQuery? params}) async {
    final response = await http.getMethod<Map<String, Object?>>(
      '/indexes',
      queryParameters: params?.toQuery(),
    );

    return Result<MeiliSearchIndex>.fromMapWithType(
      response.data!,
      (item) => MeiliSearchIndex.fromMap(this, item),
    );
  }

  /// Delete the index by matching [uid].
  Future<Task> deleteIndex(String uid) async {
    final index = this.index(uid);

    return await index.delete();
  }

  /// Update the primary Key of the index by matching [uid].
  Future<Task> updateIndex(String uid, String primaryKey) async {
    final index = this.index(uid);

    return index.update(primaryKey: primaryKey);
  }

  /// Swap indexes
  Future<Task> swapIndexes(List<SwapIndex> param) async {
    var query = param.map((e) => e.toQuery()).toList();

    final response = await http
        .postMethod<Map<String, Object?>>('/swap-indexes', data: query);

    return Task.fromMap(response.data!);
  }

  /// Return health of the Meilisearch server.
  /// Throws an error if containing details if Meilisearch can't process your request.
  Future<Map<String, dynamic>> health() async {
    final response = await http.getMethod<Map<String, dynamic>>('/health');

    return response.data!;
  }

  /// Get health of the Meilisearch server.
  /// Return true or false.
  Future<bool> isHealthy() async {
    try {
      await health();
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  /// Trigger a dump creation process.

  Future<Task> createDump() async {
    final response = await http.postMethod<Map<String, Object?>>('/dumps');

    return Task.fromMap(response.data!);
  }

  /// Get the public and private keys.
  Future<Result<Key>> getKeys({KeysQuery? params}) async {
    final response = await http.getMethod<Map<String, Object?>>('/keys',
        queryParameters: params?.toQuery());

    return Result<Key>.fromMapWithType(
        response.data!, (model) => Key.fromJson(model));
  }

  /// Get a specific key by key or uid.
  Future<Key> getKey(String keyOrUid) async {
    final response =
        await http.getMethod<Map<String, Object?>>('/keys/$keyOrUid');

    return Key.fromJson(response.data!);
  }

  /// Get the Meilisearch version
  Future<Map<String, String>> getVersion() async {
    final response = await http.getMethod<Map<String, Object?>>('/version');
    return response.data!.map((k, v) => MapEntry(k, v.toString()));
  }

  /// Get all index stats.
  Future<AllStats> getStats() async {
    final response = await http.getMethod<Map<String, Object?>>('/stats');

    return AllStats.fromMap(response.data!);
  }

  /// Create a new key.
  Future<Key> createKey({
    DateTime? expiresAt,
    String? description,
    String? uid,
    required List<String> indexes,
    required List<String> actions,
  }) async {
    final data = <String, Object?>{
      if (uid != null) 'uid': uid,
      'expiresAt': expiresAt?.toIso8601String().split('.').first,
      if (description != null) 'description': description,
      'indexes': indexes,
      'actions': actions,
    };

    final response =
        await http.postMethod<Map<String, Object?>>('/keys', data: data);

    return Key.fromJson(response.data!);
  }

  /// Update a key.
  Future<Key> updateKey(
    String key, {
    String? name,
    String? description,
  }) async {
    final data = <String, Object?>{
      if (description != null) 'description': description,
      if (name != null) 'name': name,
    };

    final response =
        await http.patchMethod<Map<String, Object?>>('/keys/$key', data: data);

    return Key.fromJson(response.data!);
  }

  /// Delete a key
  Future<bool> deleteKey(String key) async {
    final response = await http.deleteMethod<void>('/keys/$key');

    return response.statusCode == 204;
  }

  /// Generates a tenant token.
  String generateTenantToken(
    String uid,
    Object? searchRules, {
    String? apiKey,
    DateTime? expiresAt,
  }) {
    return generateToken(
      uid,
      searchRules,
      apiKey ?? this.apiKey ?? '',
      expiresAt: expiresAt,
    );
  }

  //
  // Tasks endpoints
  //

  /// Get a list of tasks from the client.
  Future<TasksResults> getTasks({TasksQuery? params}) async {
    final response = await http.getMethod<Map<String, Object?>>(
      '/tasks',
      queryParameters: params?.toQuery(),
    );

    return TasksResults.fromMap(response.data!);
  }

  /// Cancel tasks based on the input query params
  Future<Task> cancelTasks({CancelTasksQuery? params}) async {
    final response = await http.postMethod<Map<String, Object?>>(
      '/tasks/cancel',
      queryParameters: params?.toQuery(),
    );

    return Task.fromMap(response.data!);
  }

  /// Delete old processed tasks based on the input query params
  Future<Task> deleteTasks({DeleteTasksQuery? params}) async {
    final response = await http.deleteMethod<Map<String, Object?>>('/tasks',
        queryParameters: params?.toQuery());

    return Task.fromMap(response.data!);
  }

  /// Get a task from an index specified by uid with the specified uid.
  Future<Task> getTask(int uid) async {
    final response =
        await http.getMethod<Map<String, Object?>>(('/tasks/$uid'));

    return Task.fromMap(response.data!);
  }

  /// does a Multi-index search
  @RequiredMeiliServerVersion('1.1.0')
  Future<MultiSearchResult> multiSearch(MultiSearchQuery query) async {
    final response = await http.postMethod<Map<String, Object?>>(
      '/multi-search',
      data: query.toSparseMap(),
    );

    return MultiSearchResult.fromMap(response.data!);
  }

  ///
  ///Export Endpoint
  ///

  @RequiredMeiliServerVersion('1.16.0')
  Future<Task> export(ExportQuery query) async {
    final response = await http.postMethod<Map<String, Object?>>(
      '/export',
      data: query.toSparseMap(),
    );
    return Task.fromMap(response.data!);
  }
}
