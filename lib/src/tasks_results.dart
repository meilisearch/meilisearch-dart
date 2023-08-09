import 'package:meilisearch/src/task.dart';

class TasksResults {
  final List<Task> results;
  final int? next;
  final int? limit;
  final int? from;
  final int? total;
  const TasksResults({
    this.results = const [],
    this.limit,
    this.from,
    this.next,
    this.total,
  });

  factory TasksResults.fromMap(Map<String, Object?> map) => TasksResults(
        results: (map['results'] as Iterable)
            .cast<Map<String, Object?>>()
            .map((item) => Task.fromMap(item))
            .toList(),
        next: map['next'] as int?,
        from: map['from'] as int?,
        limit: map['limit'] as int?,
        total: map['total'] as int?,
      );
}
