class MeiliSearchApiException implements Exception {
  String message;
  String errorCode;
  String errorLink;
  String errorType;

  MeiliSearchApiException(String message, httpBody) {
    if (httpBody.runtimeType != String &&
        httpBody.containsKey('message') &&
        httpBody.containsKey('errorCode') &&
        httpBody.containsKey('errorLink') &&
        httpBody.containsKey('errorType')) {
      this.message = httpBody['message'];
      this.errorCode = httpBody['errorCode'];
      this.errorLink = httpBody['errorLink'];
      this.errorType = httpBody['errorType'];
    } else {
      this.message = message;
    }
  }

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
  String message;

  CommunicationException(message) {
    this.message = message;
  }

  @override
  String toString() {
    return 'An error occurred while trying to connect to the MeiliSearch instance: ${this.message}';
  }
}
