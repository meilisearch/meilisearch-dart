import 'package:meilisearch/src/update_status.dart';

import 'index_settings.dart';

import 'pending_update.dart';
import 'search_result.dart';
import 'stats.dart' show IndexStats;
import 'update_status.dart';

abstract class MeiliSearchIndex {
  String get uid;
  String? get primaryKey;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  set primaryKey(String? primaryKey);

  /// Update the primary Key of the index.
  Future<void> update({String primaryKey});

  /// Delete the index.
  Future<void> delete();

  /// Search for documents matching a specific query in the index.
  Future<SearchResult> search<T>(
    String? query, {
    int? offset,
    int? limit,
    dynamic filter,
    List<String>? facetsDistribution,
    List<String>? attributesToRetrieve,
    List<String>? attributesToCrop,
    List<String>? cropLength,
    List<String>? attributesToHighlight,
    bool? matches,
  });

  /// Return the document in the index by given [id].
  Future<Map<String, dynamic>?> getDocument(dynamic id);

  /// Return a list of all existing documents in the index.
  Future<List<Map<String, dynamic>>> getDocuments({
    int? offset,
    int? limit,
    String? attributesToRetrieve,
  });

  /// Add a list of documents by given [documents] and optional [primaryKey] parameter.
  /// If index is not exists tries to create a new index and adds documents.
  Future<PendingUpdate> addDocuments(
    List<Map<String, dynamic>> documents, {
    String? primaryKey,
  });

  /// Add a list of documents or update them if they already exist by given [documents] and optional [primaryKey] parameter.
  /// If index is not exists tries to create a new index and adds documents.
  Future<PendingUpdate> updateDocuments(
    List<Map<String, dynamic>> documents, {
    String? primaryKey,
  });

  /// Delete one document by given [id].
  Future<PendingUpdate> deleteDocument(dynamic id);

  /// Delete all documents in the specified index.
  Future<PendingUpdate> deleteAllDocuments();

  /// Delete a selection of documents by given [ids].
  Future<PendingUpdate> deleteDocuments(List<dynamic> ids);

  /// Get the settings of the index.
  Future<IndexSettings> getSettings();

  /// Get filterable attributes of the index.
  Future<List<String>> getFilterableAttributes();

  /// Reset filterable attributes of the index.
  Future<PendingUpdate> resetFilterableAttributes();

  /// Update filterable attributes of the index.
  Future<PendingUpdate> updateFilterableAttributes(
      List<String> filterableAttributes);

  /// Get the displayed attributes of the index.
  Future<List<String>> getDisplayedAttributes();

  /// Reset the displayed attributes of the index.
  Future<PendingUpdate> resetDisplayedAttributes();

  /// Update the displayed attributes of the index.
  Future<PendingUpdate> updateDisplayedAttributes(
      List<String> displayedAttributes);

  /// Get the distinct attribute for the index.
  Future<String?> getDistinctAttribute();

  /// Reset the distinct attribute for the index.
  Future<PendingUpdate> resetDistinctAttribute();

  /// Update the distinct attribute for the index.
  Future<PendingUpdate> updateDistinctAttribute(String distinctAttribute);

  /// Get ranking rules of the index.
  Future<List<String>> getRankingRules();

  /// Reset ranking rules of the index.
  Future<PendingUpdate> resetRankingRules();

  /// Update ranking rules of the index.
  Future<PendingUpdate> updateRankingRules(List<String> rankingRules);

  /// Get searchable attributes of the index.
  Future<List<String>> getSearchableAttributes();

  /// Reset searchable attributes of the index.
  Future<PendingUpdate> resetSearchableAttributes();

  /// Update the searchable attributes of the index.
  Future<PendingUpdate> updateSearchableAttributes(
      List<String> searchableAttributes);

  /// Get stop words of the index.
  Future<List<String>> getStopWords();

  /// Reset stop words of the index.
  Future<PendingUpdate> resetStopWords();

  /// Update stop words of the index
  Future<PendingUpdate> updateStopWords(List<String> stopWords);

  /// Get synonyms of the index.
  Future<Map<String, List<String>>> getSynonyms();

  /// Reset synonyms of the index.
  Future<PendingUpdate> resetSynonyms();

  /// Update synonyms of the index
  Future<PendingUpdate> updateSynonyms(Map<String, List<String>> synonyms);

  /// Reset the settings of the index.
  /// All settings will be reset to their default value.
  Future<PendingUpdate> resetSettings();

  /// Update the settings of the index. Any parameters not provided in the body will be left unchanged.
  Future<PendingUpdate> updateSettings(IndexSettings settings);

  /// Get the information of the index from the MeiliSearch server and return it.
  Future<MeiliSearchIndex> fetchInfo();

  /// Update the primaryKey of the index and return it.
  Future<String?> fetchPrimaryKey();

  /// Get stats of the index.
  Future<IndexStats> getStats();

  /// Get all update status.
  Future<List<UpdateStatus>?> getAllUpdateStatus();

  /// Gets an update status based on the update id.
  Future<UpdateStatus> getUpdateStatus(int updateId);
}
