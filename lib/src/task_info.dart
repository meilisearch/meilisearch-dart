import 'task.dart';

abstract class TaskInfo {
  int get uid;

  Future<Task> getStatus();
}
