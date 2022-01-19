import 'package:meilisearch/src/client_impl.dart';
import 'package:meilisearch/src/task.dart';

import 'task_info.dart';

class ClientTaskImpl implements TaskInfo {
  final int uid;
  final MeiliSearchClientImpl client;

  ClientTaskImpl(this.client, this.uid);

  factory ClientTaskImpl.fromMap(
    MeiliSearchClientImpl client,
    Map<String, dynamic> map,
  ) =>
      ClientTaskImpl(client, map['uid'] as int);

  @override
  Future<Task> getStatus() async {
    return await client.getTask(this.uid);
  }
}
