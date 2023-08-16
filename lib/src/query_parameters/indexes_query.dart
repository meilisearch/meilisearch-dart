import 'queryable.dart';

class IndexesQuery extends Queryable {
  final int? offset;
  final int? limit;

  const IndexesQuery({
    this.limit,
    this.offset,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'offset': offset,
      'limit': limit,
    };
  }
}
