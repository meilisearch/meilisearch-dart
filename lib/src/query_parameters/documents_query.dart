import 'package:meilisearch/src/query_parameters/queryable.dart';

class DocumentsQuery extends Queryable {
  final int? offset;
  final int? limit;
  final List<String> fields;

  DocumentsQuery({this.limit, this.offset, this.fields: const []});

  Map<String, dynamic> buildMap() {
    return {'offset': this.offset, 'limit': this.limit, 'fields': this.fields};
  }

  Map<String, dynamic> toQuery() {
    return this.buildMap()
      ..removeWhere(removeEmptyOrNulls)
      ..updateAll(toURIString);
  }
}
