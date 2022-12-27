import 'package:meilisearch/src/query_parameters/queryable.dart';

class IndexesQuery extends Queryable {
  final int? offset;
  final int? limit;

  IndexesQuery({this.limit, this.offset});
}
