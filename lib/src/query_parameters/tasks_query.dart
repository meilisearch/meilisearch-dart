class TasksQuery {
  final int? from;
  final int? next;
  final int? limit;
  List<String> status;
  List<String> type;
  List<String> indexUid;

  TasksQuery(
      {this.limit,
      this.from,
      this.next,
      this.indexUid: const [],
      this.status: const [],
      this.type: const []});

  Map<String, dynamic> toQuery() {
    return <String, dynamic>{
      'from': this.from,
      'next': this.next,
      'limit': this.limit,
      'indexUid': this.indexUid,
      'status': this.status,
      'type': this.type,
    }
      ..removeWhere((key, val) => val == null || (val is List && val.isEmpty))
      ..updateAll((key, val) => val is List ? val.join(',') : val);
  }
}
