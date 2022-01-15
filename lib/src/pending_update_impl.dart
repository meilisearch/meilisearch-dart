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
      PendingUpdateImpl(index, map['uid'] as int);

  @override
  Future<UpdateStatus> getStatus() async {
    return index.getUpdateStatus(updateId);
  }
}
