import 'package:meilisearch/src/query_parameters/queryable.dart';

class IndexesQuery extends Queryable {
  final int? offset;
  final int? limit;

  const IndexesQuery({
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
    return buildMap().removeEmptyOrNullsFromMap()..updateAll(toURIString);
  }
}
