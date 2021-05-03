class MeiliSearchApiException implements Exception {
  MeiliSearchApiException(
    this.message, {
    this.errorCode,
    this.errorLink,
    this.errorType,
  });

  factory MeiliSearchApiException.fromHttpBody(
    String message,
    dynamic httpBody,
  ) {
    if (httpBody != null &&
        httpBody.runtimeType != String &&
        httpBody.containsKey('message') &&
        httpBody.containsKey('errorCode') &&
        httpBody.containsKey('errorLink') &&
        httpBody.containsKey('errorType')) {
      return MeiliSearchApiException(
        httpBody['message'],
        errorCode: httpBody['errorCode'],
        errorLink: httpBody['errorLink'],
        errorType: httpBody['errorType'],
      );
    } else {
      return MeiliSearchApiException(message);
    }
  }

  final String message;
  final String? errorCode;
  final String? errorLink;
  final String? errorType;

  @override
  String toString() {
    var output = 'MeiliSearchApiError - message: ${this.message}';
    if (this.errorCode != null &&
        this.errorLink != null &&
        this.errorType != null) {
      output +=
          ' - errorCode: ${this.errorCode} - errorType: ${this.errorType} - errorLink: ${this.errorLink}';
    }
    return output;
  }
}

class CommunicationException implements Exception {
  CommunicationException(this.message);

  final String message;

  @override
  String toString() {
    return 'An error occurred while trying to connect to the MeiliSearch instance: $message';
  }
}
