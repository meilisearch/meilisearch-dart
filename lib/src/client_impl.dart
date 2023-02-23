import 'package:dio/dio.dart';
import 'package:meilisearch/src/query_parameters/cancel_tasks_query.dart';
import 'package:meilisearch/src/query_parameters/delete_tasks_query.dart';
import 'package:meilisearch/src/query_parameters/indexes_query.dart';
import 'package:meilisearch/src/query_parameters/keys_query.dart';
import 'package:meilisearch/src/query_parameters/tasks_query.dart';
import 'package:meilisearch/src/result.dart';
import 'package:meilisearch/src/swap_index.dart';
import 'package:meilisearch/src/tasks_results.dart';
import 'package:meilisearch/src/task.dart';
import 'package:meilisearch/src/tenant_token.dart';

import 'http_request.dart';
import 'http_request_impl.dart';

import 'client.dart';
import 'index.dart';
import 'index_impl.dart';
import 'key.dart';
import 'stats.dart' show AllStats;

class MeiliSearchClientImpl implements MeiliSearchClient {
  MeiliSearchClientImpl(this.serverUrl, [this.apiKey, this.connectTimeout])
      : http = HttpRequestImpl(serverUrl, apiKey, connectTimeout);

  @override
  final String serverUrl;

  @override
  final String? apiKey;

  @override
  final Duration? connectTimeout;

  @override
  final HttpRequest http;

  @override
  MeiliSearchIndex index(String uid) {
    return MeiliSearchIndexImpl(this, uid);
  }

  Future<Task> _update(Future<Response<Map<String, Object?>>> future) async {
    final response = await future;

    return Task.fromMap(response.data!);
  }

  @override
  Future<Task> createIndex(String uid, {String? primaryKey}) async {
    final data = <String, Object?>{
      'uid': uid,
      if (primaryKey != null) 'primaryKey': primaryKey,
    };

    return await _update(
        http.postMethod<Map<String, Object?>>('/indexes', data: data));
  }

  @override
  Future<MeiliSearchIndex> getIndex(String uid) async {
    final response = await _getIndex(uid);

    return MeiliSearchIndexImpl.fromMap(this, response.data!);
  }

  @override
  Future<Map<String, Object?>> getRawIndex(String uid) async {
    final response = await _getIndex(uid);

    return response.data!;
  }

  Future<Response<Map<String, Object?>>> _getIndex(String uid) {
    return http.getMethod<Map<String, Object?>>('/indexes/$uid');
  }

  @override
  Future<Result<MeiliSearchIndex>> getIndexes({IndexesQuery? params}) async {
    final response = await http.getMethod<Map<String, Object?>>('/indexes',
        queryParameters: params?.toQuery());

    return Result<MeiliSearchIndex>.fromMapWithType(
        response.data!, (item) => MeiliSearchIndexImpl.fromMap(this, item));
  }

  @override
  Future<Task> deleteIndex(String uid) async {
    final index = this.index(uid);

    return await index.delete();
  }

  @override
  Future<Task> updateIndex(String uid, String primaryKey) async {
    final index = this.index(uid);

    return index.update(primaryKey: primaryKey);
  }

  @override
  Future<Task> swapIndexes(List<SwapIndex> param) async {
    var query = param.map((e) => e.toQuery()).toList();

    final response = await http
        .postMethod<Map<String, Object?>>('/swap-indexes', data: query);

    return Task.fromMap(response.data!);
  }

  @override
  Future<Map<String, Object?>> health() async {
    final response = await http.getMethod<Map<String, Object?>>('/health');

    return response.data!;
  }

  @override
  Future<bool> isHealthy() async {
    try {
      await health();
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  @override
  Future<Task> createDump() async {
    final response = await http.postMethod<Map<String, Object?>>('/dumps');

    return Task.fromMap(response.data!);
  }

  @override
  Future<Result<Key>> getKeys({KeysQuery? params}) async {
    final response = await http.getMethod<Map<String, Object?>>('/keys',
        queryParameters: params?.toQuery());

    return Result<Key>.fromMapWithType(
        response.data!, (model) => Key.fromJson(model));
  }

  @override
  Future<Key> getKey(String keyOrUid) async {
    final response =
        await http.getMethod<Map<String, Object?>>('/keys/$keyOrUid');

    return Key.fromJson(response.data!);
  }

  @override
  Future<Map<String, String>> getVersion() async {
    final response = await http.getMethod<Map<String, Object?>>('/version');
    return response.data!.map((k, v) => MapEntry(k, v.toString()));
  }

  @override
  Future<AllStats> getStats() async {
    final response = await http.getMethod<Map<String, Object?>>('/stats');

    return AllStats.fromMap(response.data!);
  }

  @override
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

  @override
  Future<Key> updateKey(String key, {String? name, String? description}) async {
    final data = <String, Object?>{
      if (description != null) 'description': description,
      if (name != null) 'name': name,
    };

    final response =
        await http.patchMethod<Map<String, Object?>>('/keys/$key', data: data);

    return Key.fromJson(response.data!);
  }

  @override
  Future<bool> deleteKey(String key) async {
    final response = await http.deleteMethod<void>('/keys/$key');

    return response.statusCode == 204;
  }

  @override
  String generateTenantToken(String uid, Object? searchRules,
      {String? apiKey, DateTime? expiresAt}) {
    return generateToken(uid, searchRules, apiKey ?? this.apiKey ?? '',
        expiresAt: expiresAt);
  }

  ///
  /// Tasks endpoints
  ///

  @override
  Future<TasksResults> getTasks({TasksQuery? params}) async {
    final response = await http.getMethod<Map<String, Object?>>('/tasks',
        queryParameters: params?.toQuery());

    return TasksResults.fromMap(response.data!);
  }

  @override
  Future<Task> cancelTasks({CancelTasksQuery? params}) async {
    final response = await http.postMethod<Map<String, Object?>>(
        '/tasks/cancel',
        queryParameters: params?.toQuery());

    return Task.fromMap(response.data!);
  }

  @override
  Future<Task> deleteTasks({DeleteTasksQuery? params}) async {
    final response = await http.deleteMethod<Map<String, Object?>>('/tasks',
        queryParameters: params?.toQuery());

    return Task.fromMap(response.data!);
  }

  @override
  Future<Task> getTask(int uid) async {
    final response =
        await http.getMethod<Map<String, Object?>>(('/tasks/$uid'));

    return Task.fromMap(response.data!);
  }
}
