class Result<T> {
  final List<T> results;
  final int total;
  final int limit;
  final int offset;

  const Result({
    this.results = const [],
    this.limit = 0,
    this.offset = 0,
    this.total = 0,
  });

  factory Result.fromMapWithType(
    Map<String, Object?> map,
    T Function(Map<String, Object?> item) fromMap,
  ) =>
      Result<T>(
        results: (map['results'] as Iterable?)
                ?.cast<Map<String, Object?>>()
                .map((e) => fromMap(e))
                .toList() ??
            [],
        total: map['total'] as int,
        offset: map['offset'] as int,
        limit: map['limit'] as int,
      );

  factory Result.fromMap(Map<String, Object?> map) => Result(
        results: (map['results'] as Iterable?)?.cast<T>().toList() ?? [],
        total: map['total'] as int,
        offset: map['offset'] as int,
        limit: map['limit'] as int,
      );

  Result<TTarget> map<TTarget>(TTarget Function(T item) converter) {
    return Result(
      total: total,
      limit: limit,
      offset: offset,
      results: results.map(converter).toList(),
    );
  }
}
