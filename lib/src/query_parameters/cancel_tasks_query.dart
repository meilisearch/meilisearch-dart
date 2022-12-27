class CancelTasksQuery {
  final int? next;
  final DateTime? beforeEnqueuedAt;
  final DateTime? afterEnqueuedAt;
  final DateTime? beforeStartedAt;
  final DateTime? afterStartedAt;
  final DateTime? beforeFinishedAt;
  final DateTime? afterFinishedAt;
  List<int> uids;
  List<String> statuses;
  List<String> types;
  List<String> indexUids;

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

  Map<String, dynamic> toQuery() {
    return <String, dynamic>{
      'next': this.next,
      'beforeEnqueuedAt': this.beforeEnqueuedAt,
      'afterEnqueuedAt': this.afterEnqueuedAt,
      'beforeStartedAt': this.beforeStartedAt,
      'afterStartedAt': this.afterStartedAt,
      'beforeFinishedAt': this.beforeFinishedAt,
      'afterFinishedAt': this.afterFinishedAt,
      'uids': this.uids,
      'indexUids': this.indexUids,
      'statuses': this.statuses,
      'types': this.types,
    }
      ..removeWhere((key, val) => val == null || (val is List && val.isEmpty))
      ..updateAll(
          (key, val) => val is DateTime ? val.toUtc().toIso8601String() : val)
      ..updateAll((key, val) => val is List ? val.join(',') : val);
  }
}
