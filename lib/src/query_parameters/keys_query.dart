import 'package:meilisearch/src/query_parameters/queryable.dart';

class KeysQuery extends Queryable {
  final int? offset;
  final int? limit;

  KeysQuery({this.limit, this.offset});

  Map<String, dynamic> buildMap() {
    return {'offset': this.offset, 'limit': this.limit};
  }

  Map<String, dynamic> toQuery() {
    return this.buildMap()
      ..removeWhere(removeEmptyOrNulls)
      ..updateAll(toURIString);
  }
}
