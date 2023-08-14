import 'queryable.dart';

class KeysQuery extends Queryable {
  final int? offset;
  final int? limit;

  const KeysQuery({
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
