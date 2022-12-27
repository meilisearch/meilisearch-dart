import 'package:meilisearch/src/query_parameters/queryable.dart';

class TasksQuery extends Queryable {
  final int? from;
  final int? next;
  final int? limit;
  final int? canceledBy;
  final DateTime? beforeEnqueuedAt;
  final DateTime? afterEnqueuedAt;
  final DateTime? beforeStartedAt;
  final DateTime? afterStartedAt;
  final DateTime? beforeFinishedAt;
  final DateTime? afterFinishedAt;
  final List<int> uids;
  final List<String> statuses;
  final List<String> types;
  final List<String> indexUids;

  TasksQuery(
      {this.limit,
      this.from,
      this.next,
      this.canceledBy,
      this.beforeEnqueuedAt,
      this.afterEnqueuedAt,
      this.beforeStartedAt,
      this.afterStartedAt,
      this.beforeFinishedAt,
      this.afterFinishedAt,
      this.uids: const [],
      this.indexUids: const [],
      this.statuses: const [],
      this.types: const []});
}
