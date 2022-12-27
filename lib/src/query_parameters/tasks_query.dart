class TasksQuery {
  final int? from;
  final int? next;
  final int? limit;
  List<String> statuses;
  List<String> types;
  List<String> indexUids;

  TasksQuery(
      {this.limit,
      this.from,
      this.next,
      this.indexUids: const [],
      this.statuses: const [],
      this.types: const []});

  Map<String, dynamic> toQuery() {
    return <String, dynamic>{
      'from': this.from,
      'next': this.next,
      'limit': this.limit,
      'indexUids': this.indexUids,
      'statuses': this.statuses,
      'types': this.types,
    }
      ..removeWhere((key, val) => val == null || (val is List && val.isEmpty))
      ..updateAll((key, val) => val is List ? val.join(',') : val);
  }
}
