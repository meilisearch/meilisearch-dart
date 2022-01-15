import 'task.dart';

abstract class TaskInfo {
  int get updateId;

  Future<Task> getStatus();
}
