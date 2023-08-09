import 'queryable.dart';

class TasksQuery extends Queryable {
  final int? from;
  final int? limit;
  final DateTime? beforeEnqueuedAt;
  final DateTime? afterEnqueuedAt;
  final DateTime? beforeStartedAt;
  final DateTime? afterStartedAt;
  final DateTime? beforeFinishedAt;
  final DateTime? afterFinishedAt;
  final List<int> uids;
  final List<int> canceledBy;
  final List<String> statuses;
  final List<String> types;
  final List<String> indexUids;

  const TasksQuery({
    this.limit,
    this.from,
    this.beforeEnqueuedAt,
    this.afterEnqueuedAt,
    this.beforeStartedAt,
    this.afterStartedAt,
    this.beforeFinishedAt,
    this.afterFinishedAt,
    this.canceledBy = const [],
    this.uids = const [],
    this.indexUids = const [],
    this.statuses = const [],
    this.types = const [],
  });

  TasksQuery copyWith({
    List<int>? uids,
    List<int>? canceledBy,
    List<String>? statuses,
    List<String>? types,
    List<String>? indexUids,
  }) {
    return TasksQuery(
      from: from,
      limit: limit,
      beforeEnqueuedAt: beforeEnqueuedAt,
      afterEnqueuedAt: afterEnqueuedAt,
      beforeStartedAt: beforeStartedAt,
      afterStartedAt: afterStartedAt,
      beforeFinishedAt: beforeFinishedAt,
      afterFinishedAt: afterFinishedAt,
      uids: uids ?? this.uids,
      canceledBy: canceledBy ?? this.canceledBy,
      statuses: statuses ?? this.statuses,
      types: types ?? this.types,
      indexUids: indexUids ?? this.indexUids,
    );
  }

  @override
  Map<String, Object?> buildMap() {
    return {
      'from': from,
      'limit': limit,
      'canceledBy': canceledBy,
      'beforeEnqueuedAt': beforeEnqueuedAt,
      'afterEnqueuedAt': afterEnqueuedAt,
      'beforeStartedAt': beforeStartedAt,
      'afterStartedAt': afterStartedAt,
      'beforeFinishedAt': beforeFinishedAt,
      'afterFinishedAt': afterFinishedAt,
      'uids': uids,
      'statuses': statuses,
      'types': types,
      'indexUids': indexUids,
    };
  }
}
