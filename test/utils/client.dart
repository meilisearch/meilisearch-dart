import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:meilisearch/src/http_request_impl.dart';
import 'package:meilisearch/src/http_request.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

late HttpRequest http;
late MeiliSearchClient client;
Random random = Random();

String get testServer {
  return Platform.environment['MEILISEARCH_URL'] ?? 'http://localhost:7700';
}

Future<void> deleteAllIndexes() async {
  var data = await client.getIndexes();
  for (var item in data.results) {
    await item.delete();
  }
}

Future<void> deleteAllKeys() async {
  var data = await client.getKeys();
  for (var item in data.results) {
    await client.deleteKey(item.key);
  }
}

Future<void> setUpClient() async {
  setUp(() {
    final String server = testServer;

    client = MeiliSearchClient(server, 'masterKey');
    random = Random();
  });

  tearDown(() async {
    await deleteAllIndexes();
    await deleteAllKeys();
  });
}

Future<void> setUpHttp() async {
  setUp(() {
    final String server = testServer;

    http = HttpRequestImpl(server, 'masterKey');
  });
}

Future<void> setUpClientWithWrongUrl() async {
  setUp(() {
    final String server = 'http://wrongurl:1234';
    final connectTimeout = Duration(milliseconds: 1000);

    client = MeiliSearchClient(server, 'masterKey', connectTimeout);
  });
}

String randomUid([String prefix = 'index']) {
  return '${prefix}_${random.nextInt(9999)}';
}

// Stolen from: https://www.kindacode.com/article/flutter-dart-ways-to-generate-random-strings/
String sha1RandomString() {
  final randomNumber = random.nextDouble();
  final randomBytes = utf8.encode(randomNumber.toString());

  return sha1.convert(randomBytes).toString();
}
