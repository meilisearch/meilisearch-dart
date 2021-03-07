class MeiliSearchApiException implements Exception {
  String message;
  String errorCode;
  String errorLink;
  String errorType;

  MeiliSearchApiException(httpBody) {
    this.message = httpBody.message;
    this.errorCode = httpBody.errorCode;
    this.errorLink = httpBody.errorLink;
    this.errorType = httpBody.errorType;
  }

  @override
  String toString() {
    return 'MeiliSearchApiError - message: ${this.message} - errorCode: ${this.errorCode} - errorType: ${this.errorType} - errorLink: ${this.errorLink}';
  }
}

class CommunicationException implements Exception {
  String message;

  CommunicationException(message) {
    this.message = message;
  }

  @override
  String toString() {
    return 'An error occurred while trying to connect to the MeiliSearch instance ${this.message}';
  }
}
