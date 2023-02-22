import 'package:meilisearch/src/task.dart';

class TasksResults<T> {
  final List<Task> results;
  final int? next;
  final int? limit;
  final int? from;

  const TasksResults({
    this.results = const [],
    this.limit = null,
    this.from = null,
    this.next = null,
  });

  factory TasksResults.fromMap(Map<String, Object?> map) => TasksResults(
        results: (map['results'] as Iterable)
            .cast<Map<String, Object?>>()
            .map((item) => Task.fromMap(item))
            .toList(),
        next: map['next'] as int?,
        from: map['from'] as int?,
        limit: map['limit'] as int?,
      );
}
