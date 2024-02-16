import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:meilisearch/meilisearch.dart';

class TestMeiliSearchClient extends MeiliSearchClient {
  TestMeiliSearchClient(
    super.serverUrl, [
    super.apiKey,
    super.connectTimeout,
    super.adapter,
    super.interceptors,
  ]);

  factory TestMeiliSearchClient.withCustomDio(
    String serverUrl, {
    String? apiKey,
    Duration? connectTimeout,
    HttpClientAdapter? adapter,
    List<Interceptor>? interceptors,
  }) =>
      TestMeiliSearchClient(
        serverUrl,
        apiKey,
        connectTimeout,
        adapter,
        interceptors,
      );

  final usedIndexes = <String>{};
  final usedKeys = <String>{};

  @override
  MeiliSearchIndex index(String uid, {bool deleteWhenDone = true}) {
    if (deleteWhenDone) {
      usedIndexes.add(uid);
    }
    return super.index(uid);
  }

  @override
  Future<Task> createIndex(String uid, {String? primaryKey}) {
    usedIndexes.add(uid);
    return super.createIndex(uid, primaryKey: primaryKey);
  }

  @override
  Future<Task> deleteIndex(String uid) {
    usedIndexes.remove(uid);
    return super.deleteIndex(uid);
  }

  @override
  Future<Map<String, Object?>> getRawIndex(
    String uid, {
    bool deleteWhenDone = true,
  }) {
    return super.getRawIndex(uid).then((value) {
      if (deleteWhenDone) {
        usedIndexes.add(uid);
      }
      return value;
    }).onError((error, stackTrace) {
      usedIndexes.remove(uid);
      throw error!;
    });
  }

  @override
  Future<Task> swapIndexes(
    List<SwapIndex> param, {
    bool deleteWhenDone = true,
  }) {
    if (deleteWhenDone) {
      usedIndexes.addAll(param.map((e) => e.indexes).flattened);
    }
    return super.swapIndexes(param);
  }

  @override
  Future<Key> createKey({
    required List<String> indexes,
    required List<String> actions,
    DateTime? expiresAt,
    String? description,
    String? uid,
    bool deleteWhenDone = true,
  }) {
    return super
        .createKey(
      expiresAt: expiresAt,
      description: description,
      uid: uid,
      indexes: indexes,
      actions: actions,
    )
        .then((value) {
      if (deleteWhenDone) {
        usedKeys.add(value.key);
      }
      return value;
    });
  }

  @override
  Future<bool> deleteKey(String key) {
    usedKeys.remove(key);
    return super.deleteKey(key);
  }

  Future<void> disposeUsedResources() async {
    await Future.wait([
      _deleteUsedIndexes(),
      _deleteUsedKeys(),
    ]);
  }

  Future<void> _deleteUsedIndexes() async {
    await Future.wait(
      usedIndexes.toSet().map((e) => deleteIndex(e)),
    );
  }

  Future<void> _deleteUsedKeys() async {
    await Future.wait(
      usedKeys.toSet().map(
            (e) => deleteKey(e).onError((error, stackTrace) => false),
          ),
    );
  }
}
