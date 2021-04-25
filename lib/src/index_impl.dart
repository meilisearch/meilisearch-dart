import 'package:dio/dio.dart';

import 'client.dart';
import 'client_impl.dart';
import 'index.dart';
import 'http_request.dart';
import 'index_settings.dart';
import 'pending_update.dart';
import 'pending_update_impl.dart';
import 'search_result.dart';

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

  HttpRequest get http => client.http;

  factory MeiliSearchIndexImpl.fromMap(
    MeiliSearchClient client,
    Map<String, dynamic> map,
  ) =>
      MeiliSearchIndexImpl(
        client,
        map['uid'] as String,
        primaryKey: map['primaryKey'] as String,
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'] as String)
            : null,
        updatedAt: map['updatedAt'] != null
            ? DateTime.tryParse(map['updatedAt'] as String)
            : null,
      );

  //
  // Index endpoints
  //

  @override
  Future<void> update({String primaryKey}) async {
    final data = <String, dynamic>{
      'primaryKey': primaryKey,
    };
    data.removeWhere((k, v) => v == null);
    final response = await http.putMethod('/indexes/$uid', data: data);

    this.primaryKey = response.data['primaryKey'] as String;
    this.createdAt = DateTime.parse(response.data['createdAt'] as String);
    this.updatedAt = DateTime.parse(response.data['updatedAt'] as String);
  }

  @override
  Future<void> delete() async {
    await http.deleteMethod('/indexes/$uid');
  }

  //
  // Search endpoints
  //

  @override
  Future<SearchResult> search<T>(
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
    final response = await http.postMethod('/indexes/$uid/search', data: data);

    return SearchResult.fromMap(response.data);
  }

  //
  // Document endpoints
  //

  Future<PendingUpdateImpl> _update(Future<Response> future) async {
    final response = await future;
    return PendingUpdateImpl.fromMap(this, response.data);
  }

  @override
  Future<PendingUpdateImpl> addDocuments(documents, {String primaryKey}) async {
    return await _update(http.postMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: <String, dynamic>{
        if (primaryKey != null) 'primaryKey': primaryKey,
      },
    ));
  }

  @override
  Future<PendingUpdateImpl> updateDocuments(
    documents, {
    String primaryKey,
  }) async {
    return await _update(http.putMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: <String, dynamic>{
        if (primaryKey != null) 'primaryKey': primaryKey,
      },
    ));
  }

  @override
  Future<PendingUpdateImpl> deleteAllDocuments() async {
    return await _update(http.deleteMethod('/indexes/$uid/documents'));
  }

  @override
  Future<PendingUpdateImpl> deleteDocument(dynamic id) async {
    return await _update(http.deleteMethod('/indexes/$uid/documents/$id'));
  }

  @override
  Future<PendingUpdateImpl> deleteDocuments(List ids) async {
    return await _update(http.postMethod(
      '/indexes/$uid/documents/delete-batch',
      data: ids,
    ));
  }

  @override
  Future<Map<String, dynamic>> getDocument(id) async {
    final response = await http.getMethod<Map<String, dynamic>>(
      '/indexes/$uid/documents/$id',
    );

    return response.data;
  }

  @override
  Future<List<Map<String, dynamic>>> getDocuments({
    int offset,
    int limit,
    String attributesToRetrieve,
  }) async {
    final response = await http.getMethod<List<dynamic>>(
      '/indexes/$uid/documents',
      queryParameters: <String, dynamic>{
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (attributesToRetrieve != null)
          'attributesToRetrieve': attributesToRetrieve,
      },
    );

    return response.data.cast<Map<String, dynamic>>();
  }

  //
  // Settings endpoints
  //

  @override
  Future<IndexSettings> getSettings() async {
    final response = await http.getMethod('/indexes/$uid/settings');

    return IndexSettings.fromMap(response.data);
  }

  @override
  Future<PendingUpdate> resetSettings() async {
    return await _update(http.deleteMethod('/indexes/$uid/settings'));
  }

  @override
  Future<PendingUpdate> updateSettings(IndexSettings settings) async {
    return await _update(http.postMethod(
      '/indexes/$uid/settings',
      data: settings.toMap(),
    ));
  }
}
