import 'package:dio/dio.dart';

import 'client.dart';
import 'index.dart';
import 'index_impl.dart';

class MeiliSearchClientImpl implements MeiliSearchClient {
  MeiliSearchClientImpl(this.serverUrl, [this.masterKey])
      : dio = Dio(BaseOptions(
          baseUrl: serverUrl,
          headers: <String, dynamic>{
            if (masterKey != null) 'X-Meili-API-Key': masterKey,
          },
        ));

  @override
  final String serverUrl;

  @override
  final String masterKey;

  final Dio dio;

  @override
  Future<MeiliSearchIndex> createIndex(String uid, {String primaryKey}) async {
    final data = <String, dynamic>{
      'uid': uid,
      if (primaryKey != null) 'primaryKey': primaryKey,
    };
    data.removeWhere((k, v) => v == null);
    final response = await dio.post<Map<String, dynamic>>(
      '/indexes',
      data: data,
    );

    return MeiliSearchIndexImpl.fromMap(response.data, this);
  }

  @override
  Future<MeiliSearchIndex> getIndex(String uid) async {
    final response = await dio.get<Map<String, dynamic>>('/indexes/$uid');

    return MeiliSearchIndexImpl.fromMap(response.data, this);
  }

  @override
  Future<List<MeiliSearchIndex>> getIndexes() async {
    final response = await dio.get<List<Map<String, dynamic>>>('/indexes');

    return response.data
        .map((item) => MeiliSearchIndexImpl.fromMap(item, this))
        .toList();
  }
}
