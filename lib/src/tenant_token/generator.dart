part of tenant_token;

final _jsonEncoder = json.fuse(utf8.fuse(base64Url));

const _headers = {"typ": 'JWT', "alg": 'HS256'};

int? _getTimestamp(DateTime? time) {
  final now = DateTime.now().toUtc();

  if (time == null) return null;
  if (!time.isUtc) throw const NotUTCException();
  if (time.isBefore(now)) throw ExpiredSignatureException();

  return time.millisecondsSinceEpoch;
}

Uint8List _sign(String secretKey, String msg) {
  final hmac = Hmac(sha256, utf8.encode(secretKey));
  final body = Uint8List.fromList(utf8.encode(msg));

  return Uint8List.fromList(hmac.convert(body).bytes);
}

String _tobase64(String value) {
  return value.replaceAll(RegExp('='), '');
}

String generateToken(String uid, Object? searchRules, String apiKey,
    {DateTime? expiresAt}) {
  if (uid.isEmpty || apiKey.isEmpty) throw InvalidApiKeyException();

  final expiration = _getTimestamp(expiresAt);
  final payload = <String, Object?>{
    "searchRules": searchRules,
    "apiKeyUid": uid,
    if (expiration != null) 'exp': expiration,
  };

  final encodedHeader = _tobase64(_jsonEncoder.encode(_headers));
  final encodedBody = _tobase64(_jsonEncoder.encode(payload));
  final unsignedBody = '$encodedHeader.$encodedBody';
  final signature = _tobase64(base64Url.encode(_sign(apiKey, unsignedBody)));

  return '$unsignedBody.$signature';
}
