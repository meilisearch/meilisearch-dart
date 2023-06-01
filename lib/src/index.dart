import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:meilisearch/meilisearch.dart';
import 'result.dart';
import 'tasks_results.dart';
import 'package:collection/collection.dart';
import 'http_request.dart';
import 'stats.dart' show IndexStats;

const _ndjsonContentType = 'application/x-ndjson';
const _csvContentType = 'text/csv';

class MeiliSearchIndex {
  MeiliSearchIndex(
    this.client,
    this.uid, {
    this.primaryKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _createdAt = createdAt,
        _updatedAt = updatedAt;

  final MeiliSearchClient client;

  final String uid;
  String? primaryKey;

  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;

  HttpRequest get http => client.http;

  factory MeiliSearchIndex.fromMap(
    MeiliSearchClient client,
    Map<String, Object?> map,
  ) {
    final createdAtRaw = map['createdAt'];
    final primaryKeyRaw = map['primaryKey'];
    final updatedAtRaw = map['updatedAt'];

    return MeiliSearchIndex(
      client,
      map['uid'] as String,
      primaryKey: primaryKeyRaw is String ? primaryKeyRaw : null,
      createdAt:
          createdAtRaw is String ? DateTime.tryParse(createdAtRaw) : null,
      updatedAt:
          updatedAtRaw is String ? DateTime.tryParse(updatedAtRaw) : null,
    );
  }

  //
  // Index endpoints
  //

  /// Update the primary Key of the index.
  Future<Task> update({String? primaryKey}) async {
    final data = <String, Object?>{
      if (primaryKey != null) 'primaryKey': primaryKey,
    };

    return await _getTask(http.patchMethod('/indexes/$uid', data: data));
  }

  /// Delete the index.
  Future<Task> delete() async {
    return await _getTask(http.deleteMethod('/indexes/$uid'));
  }

  /// Get the information of the index from the Meilisearch server and return it.
  Future<MeiliSearchIndex> fetchInfo() async {
    final index = await client.getIndex(uid);
    primaryKey = index.primaryKey;
    _createdAt = index.createdAt;
    _updatedAt = index.updatedAt;
    return index;
  }

  /// Update the primaryKey of the index and return it.
  Future<String?> fetchPrimaryKey() async {
    final index = await fetchInfo();
    return index.primaryKey;
  }

  //
  // Search endpoints
  //

  /// Search for documents matching a specific query in the index.
  Future<Searcheable<Map<String, dynamic>>> search(
    String? text, [
    SearchQuery? q,
  ]) async {
    final response = await http.postMethod<Map<String, Object?>>(
      '/indexes/$uid/search',
      data: {
        'q': text,
        ...?q?.toMap(),
      },
    );
    return Searcheable.createSearchResult(response.data!, indexUid: uid);
  }

  //
  // Document endpoints
  //

  Future<Task> _getTask(Future<Response<Map<String, Object?>>> future) async {
    final response = await future;
    return Task.fromMap(response.data!);
  }

  /// {@template meili.add_docs}
  /// Add a list of documents by given [documents] and optional [primaryKey] parameter.
  /// {@endtemplate}
  ///
  /// {@template meili.index_upsert}
  /// If the index does not exist, tries to create a new index and adds documents.
  /// {@endtemplate}
  Future<Task> addDocuments(
    List<Map<String, Object?>> documents, {
    String? primaryKey,
  }) {
    return _getTask(http.postMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: {
        if (primaryKey != null) 'primaryKey': primaryKey,
      },
    ));
  }

  /// {@macro meili.add_docs}
  ///
  /// * The passed [documents] must be a valid JSON string representing an array of objects.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> addDocumentsJson(String documents, {String? primaryKey}) {
    final decoded = jsonDecode(documents);

    if (decoded is List<Object?>) {
      final casted = decoded.whereType<Map<String, Object?>>().toList();

      return addDocuments(casted, primaryKey: primaryKey);
    }

    throw MeiliSearchApiException(
      "Provided json must be an array of documents, consider using addDocumentsNdjson if this isn't the case",
    );
  }

  /// {@macro meili.add_docs}
  ///
  /// *
  /// {@template meili.csv}
  /// The passed documents must be a valid CSV string, where the first line contains objects' keys and types, and each subsequent line corresponds to an object.
  /// [see relevant documentation](https://www.meilisearch.com/docs/learn/core_concepts/documents#csv)
  /// {@endtemplate}
  ///
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> addDocumentsCsv(
    String documents, {
    String? primaryKey,
    String? csvDelimiter,
  }) {
    return _getTask(http.postMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: {
        if (primaryKey != null) 'primaryKey': primaryKey,
        if (csvDelimiter != null) 'csvDelimiter': csvDelimiter,
      },
      contentType: _csvContentType,
    ));
  }

  /// {@macro meili.add_docs}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> addDocumentsNdjson(String documents, {String? primaryKey}) {
    return _getTask(http.postMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: {
        if (primaryKey != null) 'primaryKey': primaryKey,
      },
      contentType: _ndjsonContentType,
    ));
  }

  /// {@template meili.add_docs_batches}
  /// Add a list of documents in batches of size [batchSize] by given [documents] and optional [primaryKey] parameter.
  /// {@endtemplate}
  ///
  /// {@macro meili.index_upsert}
  Future<List<Task>> addDocumentsInBatches(
    List<Map<String, dynamic>> documents, {
    int batchSize = 1000,
    String? primaryKey,
  }) =>
      Future.wait(
        documents
            .slices(batchSize)
            .map((slice) => addDocuments(slice, primaryKey: primaryKey)),
      );

  /// {@macro meili.add_docs_batches}
  ///
  /// *
  /// {@macro meili.csv}
  /// *
  /// {@macro meili.index_upsert}
  Future<List<Task>> addDocumentsCsvInBatches(
    String documents, {
    String? primaryKey,
    int batchSize = 1000,
    String? csvDelimiter,
  }) {
    final ls = LineSplitter();
    final split = ls.convert(documents);
    //header is shared for all slices
    final header = split.first;
    return Future.wait(
      split.skip(1).slices(batchSize).map(
            (slice) => addDocumentsCsv(
              [header, ...slice].join('\n'),
              primaryKey: primaryKey,
              csvDelimiter: csvDelimiter,
            ),
          ),
    );
  }

  /// {@macro meili.add_docs_batches}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<List<Task>> addDocumentsNdjsonInBatches(
    String documents, {
    String? primaryKey,
    int batchSize = 1000,
  }) {
    final ls = LineSplitter();
    final split = ls.convert(documents);

    return Future.wait(
      split.slices(batchSize).map(
            (slice) => addDocumentsNdjson(
              slice.join('\n'),
              primaryKey: primaryKey,
            ),
          ),
    );
  }

  /// {@template meili.update_docs}
  /// Add a list of documents or update them if they already exist by given [documents] and optional [primaryKey] parameter.
  /// {@endtemplate}
  ///
  /// {@macro meili.index_upsert}
  Future<Task> updateDocuments(
    List<Map<String, Object?>> documents, {
    String? primaryKey,
  }) async {
    return await _getTask(http.putMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: {
        if (primaryKey != null) 'primaryKey': primaryKey,
      },
    ));
  }

  /// {@macro meili.update_docs}
  ///
  /// * the passed [documents] must be a valid JSON string representing an array of objects.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> updateDocumentsJson(
    String documents, {
    String? primaryKey,
  }) {
    final decoded = jsonDecode(documents);

    if (decoded is List<Object?>) {
      final casted = decoded.whereType<Map<String, Object?>>().toList();

      return updateDocuments(casted, primaryKey: primaryKey);
    }

    throw MeiliSearchApiException(
      "Provided json must be an array of documents, consider using updateDocumentsNdjson if this isn't the case",
    );
  }

  /// {@macro meili.update_docs}
  ///
  /// *
  /// {@macro meili.csv}
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> updateDocumentsCsv(
    String documents, {
    String? primaryKey,
    String? csvDelimiter,
  }) {
    return _getTask(http.putMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: {
        if (primaryKey != null) 'primaryKey': primaryKey,
        if (csvDelimiter != null) 'csvDelimiter': csvDelimiter,
      },
      contentType: _csvContentType,
    ));
  }

  /// {@macro meili.update_docs}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> updateDocumentsNdjson(String documents, {String? primaryKey}) {
    return _getTask(http.putMethod(
      '/indexes/$uid/documents',
      data: documents,
      queryParameters: {
        if (primaryKey != null) 'primaryKey': primaryKey,
      },
      contentType: _ndjsonContentType,
    ));
  }

  /// {@template meili.update_docs_batches}
  /// Add a list of documents or update them if they already exist in batches of size [batchSize] by given [documents] and optional [primaryKey] parameter.
  /// {@endtemplate}
  ///
  /// {@macro meili.index_upsert}
  Future<List<Task>> updateDocumentsInBatches(
    List<Map<String, Object?>> documents, {
    int batchSize = 1000,
    String? primaryKey,
  }) =>
      Future.wait(
        documents
            .slices(batchSize)
            .map((slice) => updateDocuments(slice, primaryKey: primaryKey)),
      );

  /// {@macro meili.update_docs_batches}
  ///
  /// * The passed [documents] must be a valid CSV string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<List<Task>> updateDocumentsCsvInBatches(
    String documents, {
    String? primaryKey,
    int batchSize = 1000,
    String? csvDelimiter,
  }) {
    final ls = LineSplitter();
    final split = ls.convert(documents);
    //header is shared for all slices
    final header = split.first;

    return Future.wait(
      split.skip(1).slices(batchSize).map(
            (slice) => updateDocumentsCsv(
              [header, ...slice].join('\n'),
              primaryKey: primaryKey,
              csvDelimiter: csvDelimiter,
            ),
          ),
    );
  }

  /// {@macro meili.update_docs_batches}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<List<Task>> updateDocumentsNdjsonInBatches(
    String documents, {
    String? primaryKey,
    int batchSize = 1000,
  }) {
    final ls = LineSplitter();
    final split = ls.convert(documents);

    return Future.wait(
      split.slices(batchSize).map(
            (slice) => updateDocumentsNdjson(
              slice.join('\n'),
              primaryKey: primaryKey,
            ),
          ),
    );
  }

  /// Delete all documents in the specified index.
  Future<Task> deleteAllDocuments() async {
    return await _getTask(http.deleteMethod('/indexes/$uid/documents'));
  }

  /// Delete one document by given [id].
  Future<Task> deleteDocument(Object id) async {
    return await _getTask(http.deleteMethod('/indexes/$uid/documents/$id'));
  }

  /// Delete a selection of documents by given [ids].
  Future<Task> deleteDocuments(List<Object> ids) async {
    return await _getTask(
      http.postMethod(
        '/indexes/$uid/documents/delete-batch',
        data: ids,
      ),
    );
  }

  /// Return the document in the index by given [id].
  Future<Map<String, dynamic>?> getDocument(Object id,
      {List<String> fields = const []}) async {
    final params = DocumentsQuery(fields: fields);
    final response = await http.getMethod<Map<String, dynamic>>(
        '/indexes/$uid/documents/$id',
        queryParameters: params.toQuery());

    return response.data;
  }

  /// Return a list of all existing documents in the index.
  Future<Result<Map<String, dynamic>>> getDocuments(
      {DocumentsQuery? params}) async {
    final response = await http.getMethod<Map<String, Object?>>(
        '/indexes/$uid/documents',
        queryParameters: params?.toQuery());

    return Result.fromMap(response.data!);
  }

  //
  // Settings endpoints
  //

  /// Get the settings of the index.
  Future<IndexSettings> getSettings() async {
    final response =
        await http.getMethod<Map<String, Object?>>('/indexes/$uid/settings');

    return IndexSettings.fromMap(response.data!);
  }

  /// Reset the settings of the index.
  /// All settings will be reset to their default value.
  Future<Task> resetSettings() async {
    return await _getTask(http.deleteMethod('/indexes/$uid/settings'));
  }

  /// Update the settings of the index. Any parameters not provided in the body will be left unchanged.
  Future<Task> updateSettings(IndexSettings settings) async {
    return await _getTask(http.patchMethod(
      '/indexes/$uid/settings',
      data: settings.toMap(),
    ));
  }

  /// Get filterable attributes of the index.
  Future<List<String>> getFilterableAttributes() async {
    final response = await http.getMethod<List<Object?>>(
        '/indexes/$uid/settings/filterable-attributes');

    return response.data!.cast<String>();
  }

  /// Reset filterable attributes of the index.
  Future<Task> resetFilterableAttributes() async {
    return await _getTask(
        http.deleteMethod('/indexes/$uid/settings/filterable-attributes'));
  }

  /// Update filterable attributes of the index.
  Future<Task> updateFilterableAttributes(
    List<String> filterableAttributes,
  ) async {
    return await _getTask(
      http.putMethod(
        '/indexes/$uid/settings/filterable-attributes',
        data: filterableAttributes,
      ),
    );
  }

  /// Get the displayed attributes of the index.
  Future<List<String>> getDisplayedAttributes() async {
    final response = await http.getMethod<List<Object?>>(
        '/indexes/$uid/settings/displayed-attributes');

    return response.data!.cast<String>();
  }

  /// Reset the displayed attributes of the index.
  Future<Task> resetDisplayedAttributes() async {
    return await _getTask(
      http.deleteMethod('/indexes/$uid/settings/displayed-attributes'),
    );
  }

  /// Update the displayed attributes of the index.
  Future<Task> updateDisplayedAttributes(
      List<String> displayedAttributes) async {
    return await _getTask(
      http.putMethod(
        '/indexes/$uid/settings/displayed-attributes',
        data: displayedAttributes,
      ),
    );
  }

  /// Get the distinct attribute for the index.
  Future<String?> getDistinctAttribute() async {
    final response = await http
        .getMethod<String?>('/indexes/$uid/settings/distinct-attribute');

    return response.data;
  }

  /// Reset the distinct attribute for the index.
  Future<Task> resetDistinctAttribute() async {
    return await _getTask(
      http.deleteMethod('/indexes/$uid/settings/distinct-attribute'),
    );
  }

  /// Update the distinct attribute for the index.
  Future<Task> updateDistinctAttribute(String distinctAttribute) async {
    return await _getTask(
      http.putMethod(
        '/indexes/$uid/settings/distinct-attribute',
        data: '"$distinctAttribute"',
      ),
    );
  }

  /// Get ranking rules of the index.
  Future<List<String>> getRankingRules() async {
    final response = await http
        .getMethod<List<Object?>>('/indexes/$uid/settings/ranking-rules');

    return response.data!.cast<String>();
  }

  /// Reset ranking rules of the index.
  Future<Task> resetRankingRules() async {
    return await _getTask(
      http.deleteMethod('/indexes/$uid/settings/ranking-rules'),
    );
  }

  /// Update ranking rules of the index.
  Future<Task> updateRankingRules(List<String> rankingRules) async {
    return await _getTask(
      http.putMethod(
        '/indexes/$uid/settings/ranking-rules',
        data: rankingRules,
      ),
    );
  }

  /// Get searchable attributes of the index.
  Future<List<String>> getSearchableAttributes() async {
    final response = await http.getMethod<List<Object?>>(
      '/indexes/$uid/settings/searchable-attributes',
    );

    return response.data!.cast<String>();
  }

  /// Reset searchable attributes of the index.
  Future<Task> resetSearchableAttributes() async {
    return await _getTask(
      http.deleteMethod('/indexes/$uid/settings/searchable-attributes'),
    );
  }

  /// Update the searchable attributes of the index.
  Future<Task> updateSearchableAttributes(
      List<String> searchableAttributes) async {
    return await _getTask(
      http.putMethod(
        '/indexes/$uid/settings/searchable-attributes',
        data: searchableAttributes,
      ),
    );
  }

  //
  // StopWords endpoints
  //

  /// Get stop words of the index.
  Future<List<String>> getStopWords() async {
    final response = await http
        .getMethod<List<Object?>>('/indexes/$uid/settings/stop-words');

    return response.data!.cast<String>();
  }

  /// Reset stop words of the index.
  Future<Task> resetStopWords() async {
    return await _getTask(
        http.deleteMethod('/indexes/$uid/settings/stop-words'));
  }

  /// Update stop words of the index
  Future<Task> updateStopWords(List<String> stopWords) async {
    return await _getTask(
        http.putMethod('/indexes/$uid/settings/stop-words', data: stopWords));
  }

  //
  // Synonyms endpoints
  //

  /// Get synonyms of the index.
  Future<Map<String, List<String>>> getSynonyms() async {
    final response = await http
        .getMethod<Map<String, Object?>>('/indexes/$uid/settings/synonyms');

    return response.data!
        .map((key, value) => MapEntry(key, (value as List).cast<String>()));
  }

  /// Reset synonyms of the index.
  Future<Task> resetSynonyms() async {
    return await _getTask(http.deleteMethod('/indexes/$uid/settings/synonyms'));
  }

  /// Update synonyms of the index
  Future<Task> updateSynonyms(Map<String, List<String>> synonyms) async {
    return await _getTask(
        http.putMethod('/indexes/$uid/settings/synonyms', data: synonyms));
  }

  //
  // Sortable Attributes endpoints
  //

  /// Get sortable attributes of the index.
  Future<List<String>> getSortableAttributes() async {
    final response = await http
        .getMethod<List<Object?>>('/indexes/$uid/settings/sortable-attributes');

    return response.data!.cast<String>();
  }

  /// Reset sortable attributes of the index.
  Future<Task> resetSortableAttributes() async {
    return await _getTask(
        http.deleteMethod('/indexes/$uid/settings/sortable-attributes'));
  }

  /// Update sortable attributes of the index.
  Future<Task> updateSortableAttributes(List<String> sortableAttributes) async {
    return _getTask(
      http.putMethod(
        '/indexes/$uid/settings/sortable-attributes',
        data: sortableAttributes,
      ),
    );
  }

  //
  // Typo Tolerance endpoints
  //

  /// Get typo tolerance settings of the index.
  Future<TypoTolerance> getTypoTolerance() async {
    final response = await http.getMethod<Map<String, Object?>>(
      '/indexes/$uid/settings/typo-tolerance',
    );

    return TypoTolerance.fromMap(response.data!);
  }

  /// Reset typo tolerance settings of the index.
  Future<Task> resetTypoTolerance() async {
    return await _getTask(
      http.deleteMethod('/indexes/$uid/settings/typo-tolerance'),
    );
  }

  /// Update typo tolerance settings of the index.
  Future<Task> updateTypoTolerance(TypoTolerance typoTolerance) async {
    return await _getTask(
      http.patchMethod(
        '/indexes/$uid/settings/typo-tolerance',
        data: typoTolerance.toMap(),
      ),
    );
  }

  //
  // Pagination endpoints
  //

  /// Get pagination settings of the index.
  Future<Pagination> getPagination() async {
    final response = await http.getMethod<Map<String, Object?>>(
      '/indexes/$uid/settings/pagination',
    );

    return Pagination.fromMap(response.data!);
  }

  /// Reset pagination settings of the index.
  Future<Task> resetPagination() async {
    return await _getTask(
      http.deleteMethod('/indexes/$uid/settings/pagination'),
    );
  }

  /// Update pagination settings of the index.
  Future<Task> updatePagination(Pagination pagination) async {
    return await _getTask(
      http.patchMethod(
        '/indexes/$uid/settings/pagination',
        data: pagination.toMap(),
      ),
    );
  }

  //
  // Faceting endpoints
  //

  /// Get faceting settings of the index.
  Future<Faceting> getFaceting() async {
    final response = await http.getMethod<Map<String, Object?>>(
      '/indexes/$uid/settings/faceting',
    );

    return Faceting.fromMap(response.data!);
  }

  /// Reset faceting settings of the index.
  Future<Task> resetFaceting() async {
    return await _getTask(
      http.deleteMethod('/indexes/$uid/settings/faceting'),
    );
  }

  /// Update faceting settings of the index.
  Future<Task> updateFaceting(Faceting faceting) async {
    return await _getTask(
      http.patchMethod(
        '/indexes/$uid/settings/faceting',
        data: faceting.toMap(),
      ),
    );
  }

  //
  // Stats endponts
  //

  /// Get stats of the index.
  Future<IndexStats> getStats() async {
    final response =
        await http.getMethod<Map<String, Object?>>('/indexes/$uid/stats');

    return IndexStats.fromMap(response.data!);
  }

  //
  // Tasks endpoints
  //

  /// Get all tasks from the index.
  Future<TasksResults> getTasks({TasksQuery? params}) async {
    if (params == null) {
      params = TasksQuery(indexUids: [uid]);
    } else {
      if (!params.indexUids.contains(uid)) {
        params = params.copyWith(indexUids: [...params.indexUids, uid]);
      }
    }

    return await client.getTasks(params: params);
  }

  /// Get a task from an index specified by uid.
  Future<Task> getTask(int uid) async {
    return await client.getTask(uid);
  }
}
