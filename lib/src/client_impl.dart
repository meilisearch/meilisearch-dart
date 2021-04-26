import 'http_request.dart';
import 'http_request_impl.dart';

import 'client.dart';
import 'index.dart';
import 'index_impl.dart';
import 'exception.dart';

class MeiliSearchClientImpl implements MeiliSearchClient {
  MeiliSearchClientImpl(this.serverUrl, [this.apiKey])
      : http = HttpRequestImpl(serverUrl, apiKey);

  @override
  final String serverUrl;

  @override
  final String apiKey;

  final HttpRequest http;

  @override
  Future<MeiliSearchIndex> createIndex(String uid, {String primaryKey}) async {
    final data = <String, dynamic>{
      'uid': uid,
      if (primaryKey != null) 'primaryKey': primaryKey,
    };
    data.removeWhere((k, v) => v == null);
    final response = await http.postMethod<Map<String, dynamic>>(
      '/indexes',
      data: data,
    );

    return MeiliSearchIndexImpl.fromMap(this, response.data);
  }

  @override
  Future<MeiliSearchIndex> getIndex(String uid) async {
    final response =
        await http.getMethod<Map<String, dynamic>>('/indexes/$uid');

    return MeiliSearchIndexImpl.fromMap(this, response.data);
  }

  @override
  Future<List<MeiliSearchIndex>> getIndexes() async {
    final response = await http.getMethod<List<dynamic>>('/indexes');

    return response.data
        .cast<Map<String, dynamic>>()
        .map((item) => MeiliSearchIndexImpl.fromMap(this, item))
        .toList();
  }

  @override
  Future<MeiliSearchIndex> getOrCreateIndex(
    String uid, {
    String primaryKey,
  }) async {
    try {
      return await getIndex(uid);
    } on MeiliSearchApiException catch (_) {
      return await createIndex(uid, primaryKey: primaryKey);
    }
  }

  @override
  Future<Map<String, dynamic>> health() async {
    final response = await http.getMethod<Map<String, dynamic>>('/health');

    return response.data;
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
}
