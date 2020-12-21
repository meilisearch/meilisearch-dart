import 'update_status.dart';

abstract class PendingUpdate {
  int get updateId;

  Future<UpdateStatus> getStatus();
}
