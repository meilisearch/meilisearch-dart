import 'package:meilisearch/src/query_parameters/queryable.dart';

class DocumentsQuery extends Queryable {
  final int? offset;
  final int? limit;
  final List<String> fields;

  DocumentsQuery({this.limit, this.offset, this.fields = const []});

  Map<String, Object?> buildMap() {
    return {'offset': this.offset, 'limit': this.limit, 'fields': this.fields};
  }

  Map<String, Object> toQuery() {
    return this.buildMap().removeEmptyOrNullsFromMap()..updateAll(toURIString);
  }
}
