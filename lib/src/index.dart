import 'index_settings.dart';

import 'task_info.dart';
import 'search_result.dart';
import 'stats.dart' show IndexStats;
import 'task.dart';

abstract class MeiliSearchIndex {
  String get uid;
  String? get primaryKey;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  set primaryKey(String? primaryKey);

  /// Update the primary Key of the index.
  Future<TaskInfo> update({String primaryKey});

  /// Delete the index.
  Future<TaskInfo> delete();

  /// Search for documents matching a specific query in the index.
  Future<SearchResult> search<T>(
    String? query, {
    int? offset,
    int? limit,
    dynamic filter,
    List<String>? sort,
    List<String>? facetsDistribution,
    List<String>? attributesToRetrieve,
    List<String>? attributesToCrop,
    int? cropLength,
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
  Future<TaskInfo> addDocuments(
    List<Map<String, dynamic>> documents, {
    String? primaryKey,
  });

  /// Add a list of documents or update them if they already exist by given [documents] and optional [primaryKey] parameter.
  /// If index is not exists tries to create a new index and adds documents.
  Future<TaskInfo> updateDocuments(
    List<Map<String, dynamic>> documents, {
    String? primaryKey,
  });

  /// Delete one document by given [id].
  Future<TaskInfo> deleteDocument(dynamic id);

  /// Delete all documents in the specified index.
  Future<TaskInfo> deleteAllDocuments();

  /// Delete a selection of documents by given [ids].
  Future<TaskInfo> deleteDocuments(List<dynamic> ids);

  /// Get the settings of the index.
  Future<IndexSettings> getSettings();

  /// Get filterable attributes of the index.
  Future<List<String>> getFilterableAttributes();

  /// Reset filterable attributes of the index.
  Future<TaskInfo> resetFilterableAttributes();

  /// Update filterable attributes of the index.
  Future<TaskInfo> updateFilterableAttributes(
      List<String> filterableAttributes);

  /// Get the displayed attributes of the index.
  Future<List<String>> getDisplayedAttributes();

  /// Reset the displayed attributes of the index.
  Future<TaskInfo> resetDisplayedAttributes();

  /// Update the displayed attributes of the index.
  Future<TaskInfo> updateDisplayedAttributes(List<String> displayedAttributes);

  /// Get the distinct attribute for the index.
  Future<String?> getDistinctAttribute();

  /// Reset the distinct attribute for the index.
  Future<TaskInfo> resetDistinctAttribute();

  /// Update the distinct attribute for the index.
  Future<TaskInfo> updateDistinctAttribute(String distinctAttribute);

  /// Get ranking rules of the index.
  Future<List<String>> getRankingRules();

  /// Reset ranking rules of the index.
  Future<TaskInfo> resetRankingRules();

  /// Update ranking rules of the index.
  Future<TaskInfo> updateRankingRules(List<String> rankingRules);

  /// Get searchable attributes of the index.
  Future<List<String>> getSearchableAttributes();

  /// Reset searchable attributes of the index.
  Future<TaskInfo> resetSearchableAttributes();

  /// Update the searchable attributes of the index.
  Future<TaskInfo> updateSearchableAttributes(
      List<String> searchableAttributes);

  /// Get stop words of the index.
  Future<List<String>> getStopWords();

  /// Reset stop words of the index.
  Future<TaskInfo> resetStopWords();

  /// Update stop words of the index
  Future<TaskInfo> updateStopWords(List<String> stopWords);

  /// Get synonyms of the index.
  Future<Map<String, List<String>>> getSynonyms();

  /// Reset synonyms of the index.
  Future<TaskInfo> resetSynonyms();

  /// Update synonyms of the index
  Future<TaskInfo> updateSynonyms(Map<String, List<String>> synonyms);

  /// Get sortable attributes of the index.
  Future<List<String>> getSortableAttributes();

  /// Reset sortable attributes of the index.
  Future<TaskInfo> resetSortableAttributes();

  /// Update sortable attributes of the index.
  Future<TaskInfo> updateSortableAttributes(List<String> sortableAttributes);

  /// Reset the settings of the index.
  /// All settings will be reset to their default value.
  Future<TaskInfo> resetSettings();

  /// Update the settings of the index. Any parameters not provided in the body will be left unchanged.
  Future<TaskInfo> updateSettings(IndexSettings settings);

  /// Get the information of the index from the Meilisearch server and return it.
  Future<MeiliSearchIndex> fetchInfo();

  /// Update the primaryKey of the index and return it.
  Future<String?> fetchPrimaryKey();

  /// Get stats of the index.
  Future<IndexStats> getStats();

  /// Get all tasks from the index.
  Future<List<Task>> getTasks();

  /// Get a task from an index specified by uid.
  Future<Task> getTask(int uid);
}
