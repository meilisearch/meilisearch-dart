import 'package:meilisearch/meilisearch.dart';

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
    MeilisearchDocumentMapper<Map<String, Object?>, T> mapper,
  ) =>
      fromMap(map).map(mapper);

  static Result<Map<String, dynamic>> fromMap(Map<String, Object?> map) =>
      Result(
        results: (map['results'] as Iterable?)
                ?.cast<Map<String, Object?>>()
                .toList() ??
            [],
        total: map['total'] as int,
        offset: map['offset'] as int,
        limit: map['limit'] as int,
      );

  Result<TTarget> map<TTarget>(
    MeilisearchDocumentMapper<T, TTarget> converter,
  ) {
    return Result(
      total: total,
      limit: limit,
      offset: offset,
      results: results.map(converter).toList(),
    );
  }
}

extension ResultExt<T> on Future<Result<T>> {
  Future<Result<TTarget>> map<TTarget>(
    MeilisearchDocumentMapper<T, TTarget> mapper,
  ) {
    return then((value) => value.map(mapper));
  }
}
