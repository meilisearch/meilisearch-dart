import 'package:meilisearch/src/query_parameters/queryable.dart';

class KeysQuery extends Queryable {
  final int? offset;
  final int? limit;

  const KeysQuery({
    this.limit,
    this.offset,
  });

  Map<String, Object?> buildMap() {
    return {
      'offset': offset,
      'limit': limit,
    };
  }

  @override
  Map<String, Object> toQuery() {
    return removeEmptyOrNullsFromMap(buildMap())..updateAll(toURIString);
  }
}
