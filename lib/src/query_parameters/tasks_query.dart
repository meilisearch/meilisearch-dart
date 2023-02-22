import 'package:meilisearch/src/query_parameters/queryable.dart';

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

  @override
  Map<String, Object> toQuery() {
    return buildMap().removeEmptyOrNullsFromMap()..updateAll(toURIString);
  }
}
