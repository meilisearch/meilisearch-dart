import 'package:meilisearch/src/query_parameters/queryable.dart';

class DocumentsQuery extends Queryable {
  final int? offset;
  final int? limit;
  final List<String> fields;

  const DocumentsQuery({
    this.limit,
    this.offset,
    this.fields = const [],
  });

  Map<String, Object?> buildMap() {
    return {'offset': offset, 'limit': limit, 'fields': fields};
  }

  @override
  Map<String, Object> toQuery() {
    return removeEmptyOrNullsFromMap(buildMap())..updateAll(toURIString);
  }
}
