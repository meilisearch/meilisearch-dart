import 'package:dio/dio.dart';

import 'client.dart';
import 'index.dart';
import 'http_request.dart';
import 'index_settings.dart';
import 'pending_update.dart';
import 'pending_update_impl.dart';
import 'search_result.dart';
import 'stats.dart' show IndexStats;

class MeiliSearchIndexImpl implements MeiliSearchIndex {
  MeiliSearchIndexImpl(
    this.client,
    this.uid, {
    String? primaryKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _primaryKey = primaryKey,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  final MeiliSearchClient client;

  @override
  final String uid;

  String? _primaryKey;

  @override
  String? get primaryKey => _primaryKey;

  @override
  set primaryKey(String? primaryKey) {
    this._primaryKey = primaryKey;
  }

  DateTime? _createdAt;

  @override
  DateTime? get createdAt => _createdAt;

  DateTime? _updatedAt;

  @override
  DateTime? get updatedAt => _updatedAt;

  HttpRequest get http => client.http;

  factory MeiliSearchIndexImpl.fromMap(
    MeiliSearchClient client,
    Map<String, dynamic>? map,
  ) =>
      MeiliSearchIndexImpl(
        client,
        map?['uid'] as String,
        primaryKey: map?['primaryKey'] as String?,
        createdAt: map?['createdAt'] != null
            ? DateTime.tryParse(map?['createdAt'] as String)
            : null,
        updatedAt: map?['updatedAt'] != null
            ? DateTime.tryParse(map?['updatedAt'] as String)
            : null,
      );

  //
  // Index endpoints
  //

  @override
  Future<void> update({String? primaryKey}) async {
    final data = <String, dynamic>{
      'primaryKey': primaryKey,
    };
    data.removeWhere((k, v) => v == null);
    final response = await http.putMethod('/indexes/$uid', data: data);

    _primaryKey = response.data['primaryKey'] as String?;
    _createdAt = DateTime.parse(response.data['createdAt'] as String);
    _updatedAt = DateTime.parse(response.data['updatedAt'] as String);
  }

  @override
  Future<void> delete() async {
    await http.deleteMethod('/indexes/$uid');
  }

  @override
  Future<MeiliSearchIndex> fetchInfo() async {
    final index = await client.getIndex(uid);
    _primaryKey = index.primaryKey;
    _createdAt = index.createdAt;
    _updatedAt = index.updatedAt;
    return index;
  }

  @override
  Future<String?> fetchPrimaryKey() async {
    final index = await fetchInfo();
    return index.primaryKey;
  }

  //
  // Search endpoints
  //

  @override
  Future<SearchResult> search<T>(
    String? query, {
    int? offset,
    int? limit,
    String? filters,
    dynamic facetFilters,
    List<String>? facetsDistribution,
    List<String>? attributesToRetrieve,
    List<String>? attributesToCrop,
    List<String>? cropLength,
    List<String>? attributesToHighlight,
    bool? matches,
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
  Future<PendingUpdateImpl> addDocuments(
    documents, {
    String? primaryKey,
  }) async {
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
    String? primaryKey,
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
  Future<Map<String, dynamic>?> getDocument(id) async {
    final response = await http.getMethod<Map<String, dynamic>>(
      '/indexes/$uid/documents/$id',
    );

    return response.data;
  }

  @override
  Future<List<Map<String, dynamic>>> getDocuments({
    int? offset,
    int? limit,
    String? attributesToRetrieve,
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

    return response.data!.cast<Map<String, dynamic>>();
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

  @override
  Future<List<String>> getAttributesForFaceting() async {
    final response =
        await http.getMethod('/indexes/$uid/settings/attributes-for-faceting');

    return (response.data as List).cast<String>();
  }

  @override
  Future<PendingUpdate> resetAttributesForFaceting() async {
    return await _update(
        http.deleteMethod('/indexes/$uid/settings/attributes-for-faceting'));
  }

  @override
  Future<PendingUpdate> updateAttributesForFaceting(
      List<String> attributesForFaceting) async {
    return await _update(http.postMethod(
        '/indexes/$uid/settings/attributes-for-faceting',
        data: attributesForFaceting));
  }

  @override
  Future<List<String>> getDisplayedAttributes() async {
    final response =
        await http.getMethod('/indexes/$uid/settings/displayed-attributes');

    return (response.data as List).cast<String>();
  }

  @override
  Future<PendingUpdate> resetDisplayedAttributes() async {
    return await _update(
        http.deleteMethod('/indexes/$uid/settings/displayed-attributes'));
  }

  @override
  Future<PendingUpdate> updateDisplayedAttributes(
      List<String> displayedAttributes) async {
    return await _update(http.postMethod(
        '/indexes/$uid/settings/displayed-attributes',
        data: displayedAttributes));
  }

  @override
  Future<String?> getDistinctAttribute() async {
    final response =
        await http.getMethod('/indexes/$uid/settings/distinct-attribute');

    return response.data as String?;
  }

  @override
  Future<PendingUpdate> resetDistinctAttribute() async {
    return await _update(
        http.deleteMethod('/indexes/$uid/settings/distinct-attribute'));
  }

  @override
  Future<PendingUpdate> updateDistinctAttribute(
      String distinctAttribute) async {
    return await _update(http.postMethod(
        '/indexes/$uid/settings/distinct-attribute',
        data: '"$distinctAttribute"'));
  }

  @override
  Future<List<String>> getRankingRules() async {
    final response =
        await http.getMethod('/indexes/$uid/settings/ranking-rules');

    return (response.data as List).cast<String>();
  }

  @override
  Future<PendingUpdate> resetRankingRules() async {
    return await _update(
        http.deleteMethod('/indexes/$uid/settings/ranking-rules'));
  }

  @override
  Future<PendingUpdate> updateRankingRules(List<String> rankingRules) async {
    return await _update(http.postMethod('/indexes/$uid/settings/ranking-rules',
        data: rankingRules));
  }

  @override
  Future<List<String>> getStopWords() async {
    final response = await http.getMethod('/indexes/$uid/settings/stop-words');

    return (response.data as List).cast<String>();
  }

  @override
  Future<PendingUpdate> resetStopWords() async {
    return await _update(
        http.deleteMethod('/indexes/$uid/settings/stop-words'));
  }

  @override
  Future<List<String>> getSearchableAttributes() async {
    final response =
        await http.getMethod('/indexes/$uid/settings/searchable-attributes');

    return (response.data as List).cast<String>();
  }

  @override
  Future<PendingUpdate> resetSearchableAttributes() async {
    return await _update(
        http.deleteMethod('/indexes/$uid/settings/searchable-attributes'));
  }

  @override
  Future<PendingUpdate> updateSearchableAttributes(
      List<String> searchableAttributes) async {
    return await _update(http.postMethod(
        '/indexes/$uid/settings/searchable-attributes',
        data: searchableAttributes));
  }

  @override
  Future<PendingUpdate> updateStopWords(List<String> stopWords) async {
    return await _update(
        http.postMethod('/indexes/$uid/settings/stop-words', data: stopWords));
  }

  @override
  Future<Map<String, List<String>>> getSynonyms() async {
    final response = await http.getMethod('/indexes/$uid/settings/synonyms');

    return (response.data as Map)
        .cast<String, List>()
        .map((k, v) => MapEntry(k, v.cast<String>()));
  }

  @override
  Future<PendingUpdate> resetSynonyms() async {
    return await _update(http.deleteMethod('/indexes/$uid/settings/synonyms'));
  }

  @override
  Future<PendingUpdate> updateSynonyms(
      Map<String, List<String>> synonyms) async {
    return await _update(
        http.postMethod('/indexes/$uid/settings/synonyms', data: synonyms));
  }

  ///
  /// Stats endponts
  ///

  @override
  Future<IndexStats> getStats() async {
    final response = await http.getMethod('/indexes/$uid/stats');

    return IndexStats.fromMap(response.data);
  }
}
