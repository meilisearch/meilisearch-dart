import 'package:meilisearch/src/query_parameters/queryable.dart';

class KeysQuery extends Queryable {
  final int? offset;
  final int? limit;

  KeysQuery({this.limit, this.offset});
}
