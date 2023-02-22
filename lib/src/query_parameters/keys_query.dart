import 'package:meilisearch/src/query_parameters/queryable.dart';

class KeysQuery extends Queryable {
  final int? offset;
  final int? limit;

  KeysQuery({this.limit, this.offset});

  Map<String, Object?> buildMap() {
    return {
      'offset': this.offset,
      'limit': this.limit,
    };
  }

  Map<String, Object> toQuery() {
    return this.buildMap().removeEmptyOrNullsFromMap()..updateAll(toURIString);
  }
}
