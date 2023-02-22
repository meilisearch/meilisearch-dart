class MeiliSearchApiException implements Exception {
  MeiliSearchApiException(
    this.message, {
    this.code,
    this.link,
    this.type,
  });

  factory MeiliSearchApiException.fromHttpBody(
    String message,
    Object? httpBody,
  ) {
    if (httpBody != null &&
        httpBody is Map<String, Object?> &&
        httpBody.containsKey('message') &&
        httpBody.containsKey('code') &&
        httpBody.containsKey('link') &&
        httpBody.containsKey('type')) {
      return MeiliSearchApiException(
        httpBody['message'] as String? ?? "",
        code: httpBody['code'] as String?,
        link: httpBody['link'] as String?,
        type: httpBody['type'] as String?,
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
