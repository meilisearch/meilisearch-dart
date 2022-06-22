class Result<T> {
  final List<dynamic> results;
  final int total;
  final int limit;
  final int offset;

  Result(
      {this.results: const [], this.limit: 0, this.offset: 0, this.total: 0});

  factory Result.fromMapWithType(Map<String, dynamic> map, fromMap) =>
      Result<T>(
        results: map['results'].map((e) => fromMap(e)).toList(),
        total: map['total'] as int,
        offset: map['offset'] as int,
        limit: map['limit'] as int,
      );

  factory Result.fromMap(Map<String, dynamic> map) => Result(
        results: map['results'] as List<T>,
        total: map['total'] as int,
        offset: map['offset'] as int,
        limit: map['limit'] as int,
      );
}
