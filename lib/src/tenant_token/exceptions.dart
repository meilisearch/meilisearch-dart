part of tenant_token;

class ExpiredSignatureException implements Exception {
  const ExpiredSignatureException();
}

class NotUTCException implements Exception {
  const NotUTCException();
}

class InvalidApiKeyException implements Exception {
  const InvalidApiKeyException();
}
