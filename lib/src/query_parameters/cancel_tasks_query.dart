import 'package:meilisearch/src/query_parameters/queryable.dart';

class CancelTasksQuery extends Queryable {
  final int? next;
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

  CancelTasksQuery(
      {this.next,
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
