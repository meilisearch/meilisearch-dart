class TaskError {
  TaskError({
    this.message,
    this.code,
    this.type,
    this.link,
  });

  final String? message;
  final String? code;
  final String? type;
  final String? link;

  factory TaskError.fromMap(Map<String, Object?> map) => TaskError(
        message: map['message'] as String?,
        code: map['code'] as String?,
        type: map['type'] as String?,
        link: map['link'] as String?,
      );

  @override
  String toString() {
    return 'TaskError{message: $message, code: $code, type: $type, link: $link}';
  }
}
