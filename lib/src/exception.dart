class MeiliSearchApiException implements Exception {
  MeiliSearchApiException(
    this.message, {
    this.code,
    this.link,
    this.type,
  });

  factory MeiliSearchApiException.fromHttpBody(
    String message,
    dynamic httpBody,
  ) {
    if (httpBody != null &&
        httpBody.runtimeType != String &&
        httpBody.containsKey('message') &&
        httpBody.containsKey('code') &&
        httpBody.containsKey('link') &&
        httpBody.containsKey('type')) {
      return MeiliSearchApiException(
        httpBody['message'],
        code: httpBody['code'],
        link: httpBody['link'],
        type: httpBody['type'],
      );
    } else {
      return MeiliSearchApiException(message);
    }
  }

  final String message;
  final String? code;
  final String? link;
  final String? type;

  @override
  String toString() {
    var output = 'MeiliSearchApiError - message: ${this.message}';
    if (this.code != null && this.link != null && this.type != null) {
      output +=
          ' - code: ${this.code} - type: ${this.type} - link: ${this.link}';
    }
    return output;
  }
}

class CommunicationException implements Exception {
  CommunicationException(this.message);

  final String message;

  @override
  String toString() {
    return 'An error occurred while trying to connect to the Meilisearch instance: $message';
  }
}
