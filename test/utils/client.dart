import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:meilisearch/src/http_request.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

import '../models/test_client.dart';

HttpRequest get http => client.http;
late TestMeiliSearchClient client;
final random = Random();

const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');
String get testServer {
  const defaultUrl = 'http://localhost:7700';
  if (_kIsWeb) {
    return defaultUrl;
  } else {
    return Platform.environment['MEILISEARCH_URL'] ?? defaultUrl;
  }
}

String get testApiKey {
  return 'masterKey';
}

Version? get meiliServerVersion {
  const meilisearchVersionKey = 'MEILISEARCH_VERSION';
  String? compileTimeValue = String.fromEnvironment(meilisearchVersionKey);
  if (compileTimeValue.isEmpty) {
    compileTimeValue = null;
  }
  if (_kIsWeb) {
    if (compileTimeValue != null) {
      return Version.parse(compileTimeValue);
    }
  } else {
    var str = Platform.environment[meilisearchVersionKey] ?? compileTimeValue;
    if (str != null && str.isNotEmpty) {
      return Version.parse(str);
    }
  }
  return null;
}

String? get openAiKey {
  const keyName = "OPEN_AI_API_KEY";
  String? compileTimeValue = String.fromEnvironment(keyName);
  if (compileTimeValue.isEmpty) {
    compileTimeValue = null;
  }
  if (_kIsWeb) {
    return compileTimeValue;
  } else {
    return Platform.environment[keyName] ?? compileTimeValue;
  }
}

void setUpClient() {
  setUp(() {
    client = TestMeiliSearchClient(testServer, testApiKey);
  });
  tearDown(() => client.disposeUsedResources());
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
