import 'search_result.dart';
import 'serializer.dart';

abstract class MeiliSearchIndex {
  String get uid;
  String get primaryKey;
  DateTime get createdAt;
  DateTime get updatedAt;

  Future<void> update({String primaryKey});
  Future<void> delete();
  Future<SearchResult<T>> search<T>(
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
    Serializer<T> serializer,
  });
}
