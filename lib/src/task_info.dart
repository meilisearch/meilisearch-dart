class TaskInfo {
  final int taskUid;

  TaskInfo(this.taskUid);

  factory TaskInfo.fromMap(
    Map<String, dynamic> map,
  ) =>
      TaskInfo((map['uid'] ?? map['taskUid']) as int);
}
