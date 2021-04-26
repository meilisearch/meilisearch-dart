import 'package:meilisearch/src/update_status.dart';

import 'index_impl.dart';
import 'pending_update.dart';

class PendingUpdateImpl implements PendingUpdate {
  final int updateId;
  final MeiliSearchIndexImpl index;

  PendingUpdateImpl(this.index, this.updateId);

  factory PendingUpdateImpl.fromMap(
    MeiliSearchIndexImpl index,
    Map<String, dynamic> map,
  ) =>
      PendingUpdateImpl(index, map['updateId'] as int);

  @override
  Future<UpdateStatus> getStatus() async {
    final response = await index.http.getMethod<Map<String, dynamic>>(
      '/indexes/${index.uid}/updates/$updateId',
    );

    return UpdateStatus.fromMap(response.data);
  }
}
