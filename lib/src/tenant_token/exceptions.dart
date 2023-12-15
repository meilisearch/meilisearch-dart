part of '../tenant_token.dart';

class ExpiredSignatureException implements Exception {
  const ExpiredSignatureException();
}

class NotUTCException implements Exception {
  const NotUTCException();
}

class InvalidApiKeyException implements Exception {
  const InvalidApiKeyException();
}
