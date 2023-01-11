import 'package:meilisearch/src/query_parameters/queryable.dart';

class DeleteTasksQuery extends Queryable {
  final int? next;
  final DateTime? beforeEnqueuedAt;
  final DateTime? afterEnqueuedAt;
  final DateTime? beforeStartedAt;
  final DateTime? afterStartedAt;
  final DateTime? beforeFinishedAt;
  final DateTime? afterFinishedAt;
  final List<int> canceledBy;
  final List<int> uids;
  final List<String> statuses;
  final List<String> types;
  final List<String> indexUids;

  DeleteTasksQuery(
      {this.next,
      this.beforeEnqueuedAt,
      this.afterEnqueuedAt,
      this.beforeStartedAt,
      this.afterStartedAt,
      this.beforeFinishedAt,
      this.afterFinishedAt,
      this.canceledBy: const [],
      this.uids: const [],
      this.indexUids: const [],
      this.statuses: const [],
      this.types: const []});
}
