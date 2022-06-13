import 'task.dart';

abstract class TaskInfo {
  int get taskUid;

  Future<Task> getStatus();
}
