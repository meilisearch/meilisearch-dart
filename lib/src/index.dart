import 'index_settings.dart';

import 'pending_update.dart';
import 'search_result.dart';

abstract class MeiliSearchIndex {
  String get uid;
  String get primaryKey;
  DateTime get createdAt;
  DateTime get updatedAt;

  Future<void> update({String primaryKey});
  Future<void> delete();

  Future<SearchResult> search<T>(
    String query, {
    int offset,
    int limit,
    String filters,
    dynamic facetFilters,
    List<String> facetsDistribution,
    List<String> attributesToRetrieve,
    List<String> attributesToCrop,
    List<String> cropLength,
    List<String> attributesToHighlight,
    bool matches,
  });

  Future<Map<String, dynamic>> getDocument(dynamic id);
  Future<List<Map<String, dynamic>>> getDocuments({
    int offset,
    int limit,
    String attributesToRetrieve,
  });
  Future<PendingUpdate> addDocuments(
    List<Map<String, dynamic>> documents, {
    String primaryKey,
  });
  Future<PendingUpdate> updateDocuments(
    List<Map<String, dynamic>> documents, {
    String primaryKey,
  });
  Future<PendingUpdate> deleteDocument(dynamic id);
  Future<PendingUpdate> deleteAllDocuments();
  Future<PendingUpdate> deleteDocuments(List<dynamic> ids);

  Future<IndexSettings> getSettings();
  Future<PendingUpdate> resetSettings();
  Future<PendingUpdate> updateSettings(IndexSettings settings);
}
