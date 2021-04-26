import 'dart:io';
import 'dart:math';

import 'package:meilisearch/src/http_request_impl.dart';
import 'package:meilisearch/src/http_request.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/pending_update.dart';
import 'package:meilisearch/src/update_status.dart';
import 'package:test/test.dart';

HttpRequest http;
MeiliSearchClient client;
Random random = Random();

Future<void> deleteAllIndexes() async {
  var indexes = await client.getIndexes();
  for (var item in indexes) {
    await item.delete();
  }
}

Future<void> setUpClient() async {
  setUp(() {
    var server = 'http://localhost:7700';
    if (Platform.environment.containsKey('MEILI_SERVER')) {
      server = Platform.environment['MEILI_SERVER'];
    }

    print('Using MeiliSearch server on $server for running tests.');

    client = MeiliSearchClient(server, 'masterKey');
    random = Random();
  });

  tearDown(() async {
    await deleteAllIndexes();
  });
}

Future<void> setUpHttp() async {
  setUp(() {
    var server = 'http://localhost:7700';
    if (Platform.environment.containsKey('MEILI_SERVER')) {
      server = Platform.environment['MEILI_SERVER'];
    }

    http = HttpRequestImpl(server, 'masterKey');
  });
}

Future<void> setUpClientWithWrongUrl() async {
  setUp(() {
    var server = 'http://wrongurl:1234';

    print('Using wrong url server on $server for running tests.');

    client = MeiliSearchClient(server, 'masterKey');
  });
}

String randomUid([String prefix = 'index']) {
  return '${prefix}_${random.nextInt(9999)}';
}

extension PendingUpdateX on PendingUpdate {
  Future<UpdateStatus> waitFor({
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 50),
  }) async {
    var endingTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endingTime)) {
      var response = await getStatus();
      if (response.status != 'enqueued') {
        return response;
      }
      await Future.delayed(interval);
    }

    throw Exception('The task ${updateId} timed out.');
  }
}

extension PendingUpdateFutureX on Future<PendingUpdate> {
  Future<UpdateStatus> waitFor({
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 50),
  }) async {
    return await (await this).waitFor(
      timeout: timeout,
      interval: interval,
    );
  }
}
