import 'package:meilisearch/src/query_parameters/queryable.dart';

class IndexesQuery extends Queryable {
  final int? offset;
  final int? limit;

  IndexesQuery({this.limit, this.offset});

  Map<String, Object?> buildMap() {
    return {'offset': this.offset, 'limit': this.limit};
  }

  Map<String, Object> toQuery() {
    return this.buildMap().removeEmptyOrNullsFromMap()..updateAll(toURIString);
  }
}
