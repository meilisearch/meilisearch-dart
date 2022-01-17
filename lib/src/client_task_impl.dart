import 'package:meilisearch/src/client_impl.dart';
import 'package:meilisearch/src/update_status.dart';

import 'pending_update.dart';

class ClientTaskImpl implements PendingUpdate {
  final int updateId;
  final MeiliSearchClientImpl client;

  ClientTaskImpl(this.client, this.updateId);

  factory ClientTaskImpl.fromMap(
    MeiliSearchClientImpl client,
    Map<String, dynamic> map,
  ) =>
      ClientTaskImpl(client, map['uid'] as int);

  @override
  Future<UpdateStatus> getStatus() async {
    final response = await client.http.getMethod(('/tasks/${this.updateId}'));

    return UpdateStatus.fromMap(response.data);
  }
}
