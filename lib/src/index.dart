import 'package:meilisearch/src/query_parameters/documents_query.dart';
import 'package:meilisearch/src/query_parameters/tasks_query.dart';
import 'package:meilisearch/src/result.dart';
import 'package:meilisearch/src/searchable.dart';
import 'package:meilisearch/src/tasks_results.dart';

import 'filter_builder/filter_builder_base.dart';
import 'index_settings.dart';

import 'matching_strategy_enum.dart';
import 'stats.dart' show IndexStats;
import 'task.dart';
import 'typo_tolerance.dart';

abstract class MeiliSearchIndex {
  String get uid;
  String? get primaryKey;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  set primaryKey(String? primaryKey);

  /// Update the primary Key of the index.
  Future<Task> update({String primaryKey});

  /// Delete the index.
  Future<Task> delete();

  /// Search for documents matching a specific query in the index.
  Future<Searcheable> search(
    String? query, {
    int? offset,
    int? limit,
    int? page,
    int? hitsPerPage,

    /// filter is either a list or a string
    Object? filter,
    MeiliOperatorExpressionBase? filterExpression,
    List<String>? sort,
    List<String>? facets,
    List<String>? attributesToRetrieve,
    List<String>? attributesToCrop,
    int? cropLength,
    List<String>? attributesToHighlight,
    bool? showMatchesPosition,
    String? cropMarker,
    String? highlightPreTag,
    String? highlightPostTag,
    MatchingStrategy? matchingStrategy,
  });

  /// Return the document in the index by given [id].
  Future<Map<String, Object?>?> getDocument(Object id, {List<String> fields});

  /// Return a list of all existing documents in the index.
  Future<Result<Map<String, Object?>>> getDocuments({DocumentsQuery? params});

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
  });

  /// {@macro meili.add_docs}
  ///
  /// * The passed [documents] must be a valid JSON string representing an array of objects.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> addDocumentsJson(
    String documents, {
    String? primaryKey,
  });

  /// {@macro meili.add_docs}
  ///
  /// *
  /// {@template meili.csv}
  /// The passed documents must be a valid CSV string, where the first line contains objects' keys and types, and each subsequent line corresponds to an object.
  /// [see relevant documentation](https://docs.meilisearch.com/learn/core_concepts/documents.html#csv)
  /// {@endtemplate}
  ///
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> addDocumentsCsv(
    String documents, {
    String? primaryKey,
  });

  /// {@macro meili.add_docs}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> addDocumentsNdjson(
    String documents, {
    String? primaryKey,
  });

  /// {@template meili.add_docs_batches}
  /// Add a list of documents in batches of size [batchSize] by given [documents] and optional [primaryKey] parameter.
  /// {@endtemplate}
  ///
  /// {@macro meili.index_upsert}
  Future<List<Task>> addDocumentsInBatches(
    List<Map<String, Object?>> documents, {
    int batchSize = 1000,
    String? primaryKey,
  });

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
  });

  /// {@macro meili.add_docs_batches}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<List<Task>> addDocumentsNdjsonInBatches(
    String documents, {
    String? primaryKey,
    int batchSize = 1000,
  });

  /// {@template meili.update_docs}
  /// Add a list of documents or update them if they already exist by given [documents] and optional [primaryKey] parameter.
  /// {@endtemplate}
  ///
  /// {@macro meili.index_upsert}
  Future<Task> updateDocuments(
    List<Map<String, Object?>> documents, {
    String? primaryKey,
  });

  /// {@macro meili.update_docs}
  ///
  /// * the passed [documents] must be a valid JSON string representing an array of objects.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> updateDocumentsJson(
    String documents, {
    String? primaryKey,
  });

  /// {@macro meili.update_docs}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> updateDocumentsNdjson(
    String documents, {
    String? primaryKey,
  });

  /// {@macro meili.update_docs}
  ///
  /// *
  /// {@macro meili.csv}
  /// *
  /// {@macro meili.index_upsert}
  Future<Task> updateDocumentsCsv(
    String documents, {
    String? primaryKey,
  });

  /// {@template meili.update_docs_batches}
  /// Add a list of documents or update them if they already exist in batches of size [batchSize] by given [documents] and optional [primaryKey] parameter.
  /// {@endtemplate}
  ///
  /// {@macro meili.index_upsert}
  Future<List<Task>> updateDocumentsInBatches(
    List<Map<String, Object?>> documents, {
    int batchSize = 1000,
    String? primaryKey,
  });

  /// {@macro meili.update_docs_batches}
  ///
  /// * The passed [documents] must be a valid CSV string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<List<Task>> updateDocumentsCsvInBatches(
    String documents, {
    String? primaryKey,
    int batchSize = 1000,
  });

  /// {@macro meili.update_docs_batches}
  ///
  /// * The passed [documents] must be a valid Newline Delimited Json (NdJson) string, where each line corresponds to an object.
  /// *
  /// {@macro meili.index_upsert}
  Future<List<Task>> updateDocumentsNdjsonInBatches(
    String documents, {
    String? primaryKey,
    int batchSize = 1000,
  });

  /// Delete one document by given [id].
  Future<Task> deleteDocument(Object id);

  /// Delete all documents in the specified index.
  Future<Task> deleteAllDocuments();

  /// Delete a selection of documents by given [ids].
  Future<Task> deleteDocuments(List<Object> ids);

  /// Get the settings of the index.
  Future<IndexSettings> getSettings();

  /// Get filterable attributes of the index.
  Future<List<String>> getFilterableAttributes();

  /// Reset filterable attributes of the index.
  Future<Task> resetFilterableAttributes();

  /// Update filterable attributes of the index.
  Future<Task> updateFilterableAttributes(List<String> filterableAttributes);

  /// Get the displayed attributes of the index.
  Future<List<String>> getDisplayedAttributes();

  /// Reset the displayed attributes of the index.
  Future<Task> resetDisplayedAttributes();

  /// Update the displayed attributes of the index.
  Future<Task> updateDisplayedAttributes(List<String> displayedAttributes);

  /// Get the distinct attribute for the index.
  Future<String?> getDistinctAttribute();

  /// Reset the distinct attribute for the index.
  Future<Task> resetDistinctAttribute();

  /// Update the distinct attribute for the index.
  Future<Task> updateDistinctAttribute(String distinctAttribute);

  /// Get ranking rules of the index.
  Future<List<String>> getRankingRules();

  /// Reset ranking rules of the index.
  Future<Task> resetRankingRules();

  /// Update ranking rules of the index.
  Future<Task> updateRankingRules(List<String> rankingRules);

  /// Get searchable attributes of the index.
  Future<List<String>> getSearchableAttributes();

  /// Reset searchable attributes of the index.
  Future<Task> resetSearchableAttributes();

  /// Update the searchable attributes of the index.
  Future<Task> updateSearchableAttributes(List<String> searchableAttributes);

  /// Get stop words of the index.
  Future<List<String>> getStopWords();

  /// Reset stop words of the index.
  Future<Task> resetStopWords();

  /// Update stop words of the index
  Future<Task> updateStopWords(List<String> stopWords);

  /// Get synonyms of the index.
  Future<Map<String, List<String>>> getSynonyms();

  /// Reset synonyms of the index.
  Future<Task> resetSynonyms();

  /// Update synonyms of the index
  Future<Task> updateSynonyms(Map<String, List<String>> synonyms);

  /// Get sortable attributes of the index.
  Future<List<String>> getSortableAttributes();

  /// Reset sortable attributes of the index.
  Future<Task> resetSortableAttributes();

  /// Update sortable attributes of the index.
  Future<Task> updateSortableAttributes(List<String> sortableAttributes);

  /// Get typo tolerance settings of the index.
  Future<TypoToleranceSettings> getTypoTolerance();

  /// Reset typo tolerance settings of the index.
  Future<Task> resetTypoTolerance();

  /// Update typo tolerance settings of the index.
  Future<Task> updateTypoTolerance(TypoToleranceSettings typoTolerance);

  /// Reset the settings of the index.
  /// All settings will be reset to their default value.
  Future<Task> resetSettings();

  /// Update the settings of the index. Any parameters not provided in the body will be left unchanged.
  Future<Task> updateSettings(IndexSettings settings);

  /// Get the information of the index from the Meilisearch server and return it.
  Future<MeiliSearchIndex> fetchInfo();

  /// Update the primaryKey of the index and return it.
  Future<String?> fetchPrimaryKey();

  /// Get stats of the index.
  Future<IndexStats> getStats();

  /// Get all tasks from the index.
  Future<TasksResults> getTasks({TasksQuery? params});

  /// Get a task from an index specified by uid.
  Future<Task> getTask(int uid);
}
