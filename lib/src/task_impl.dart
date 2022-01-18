import 'package:meilisearch/src/task.dart';

import 'index_impl.dart';
import 'task_info.dart';

class TaskImpl implements TaskInfo {
  final int uid;
  final MeiliSearchIndexImpl index;

  TaskImpl(this.index, this.uid);

  factory TaskImpl.fromMap(
    MeiliSearchIndexImpl index,
    Map<String, dynamic> map,
  ) =>
      TaskImpl(index, map['uid'] as int);

  @override
  Future<Task> getStatus() async {
    return index.getTask(uid);
  }
}
