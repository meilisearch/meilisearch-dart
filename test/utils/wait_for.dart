import 'package:meilisearch/meilisearch.dart';

extension TaskWaiter on Task {
  Future<Task> waitFor({
    required MeiliSearchClient client,
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 50),
  }) async {
    var endingTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endingTime)) {
      var task = await client.getTask(this.uid!);

      if (task.status != 'enqueued' && task.status != 'processing') {
        return task;
      }

      await Future.delayed(interval);
    }

    throw Exception('The task ${this.uid!} timed out.');
  }
}

extension TaskWaiterForFutures on Future<Task> {
  Future<Task> waitFor({
    required MeiliSearchClient client,
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 50),
  }) async {
    return await (await this)
        .waitFor(timeout: timeout, interval: interval, client: client);
  }
}
