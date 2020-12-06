import 'package:dio/dio.dart';

import 'client.dart';
import 'client_impl.dart';
import 'index.dart';
import 'search_result.dart';
import 'search_result.dart';
import 'serializer.dart';

class MeiliSearchIndexImpl implements MeiliSearchIndex {
  MeiliSearchIndexImpl(
    this.client,
    this.uid, {
    this.primaryKey,
    this.createdAt,
    this.updatedAt,
  });

  final MeiliSearchClientImpl client;

  @override
  final String uid;

  @override
  String primaryKey;

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  Dio get dio => client.dio;

  factory MeiliSearchIndexImpl.fromMap(
    Map<String, dynamic> map,
    MeiliSearchClient client,
  ) =>
      MeiliSearchIndexImpl(
        client,
        map['uid'] as String,
        primaryKey: map['primaryKey'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );

  @override
  Future<void> delete() async {
    await dio.delete('/indexes/$uid');
  }

  @override
  Future<void> update({String primaryKey}) async {
    final data = <String, dynamic>{
      'primaryKey': primaryKey,
    };
    data.removeWhere((k, v) => v == null);
    final response = await dio.put<Map<String, dynamic>>(
      '/indexes/$uid',
      data: data,
    );

    primaryKey = response.data['primaryKey'] as String;
    createdAt = DateTime.parse(response.data['createdAt'] as String);
    updatedAt = DateTime.parse(response.data['updatedAt'] as String);
  }

  @override
  Future<SearchResult<T>> search<T>(
    String query, {
    int offset,
    int limit,
    String filters,
    facetFilters,
    List<String> facetsDistribution,
    List<String> attributesToRetrieve,
    List<String> attributesToCrop,
    List<String> cropLength,
    List<String> attributesToHighlight,
    bool matches,
    Serializer<T> serializer,
  }) async {
    final data = <String, dynamic>{
      'q': query,
      'offset': offset,
      'limit': limit,
      'filters': filters,
      'facetFilters': facetFilters,
      'facetsDistribution': facetsDistribution,
      'attributesToRetrieve': attributesToRetrieve,
      'attributesToCrop': attributesToCrop,
      'cropLength': cropLength,
      'attributesToHighlight': attributesToHighlight,
      'matches': matches,
    };
    data.removeWhere((k, v) => v == null);
    final response = await dio.post<Map<String, dynamic>>(
      '/indexes/$uid/search',
      data: data,
    );

    return SearchResult<T>.fromMap(response.data, serializer: serializer);
  }
}
