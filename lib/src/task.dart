class Task {
  Task({
    this.status,
    this.uid,
    this.indexUid,
    this.type,
    this.duration,
    this.enqueuedAt,
    this.processedAt,
    this.error,
    this.details,
  });

  final String? status;
  final int? uid;
  final String? indexUid;
  final String? type;
  final String? duration;
  final DateTime? enqueuedAt;
  final DateTime? processedAt;
  final TaskError? error;
  final Map<String, Object?>? details;

  factory Task.fromMap(Map<String, Object?> map) {
    final enqueuedAtRaw = map['enqueuedAt'];
    final processedAtRaw = map['processedAt'];
    final errorRaw = map['error'];

    return Task(
      status: map['status'] as String?,
      uid: (map['uid'] ?? map['taskUid']) as int?,
      indexUid: map['indexUid'] as String?,
      duration: map['duration'] as String?,
      enqueuedAt:
          enqueuedAtRaw is String ? DateTime.tryParse(enqueuedAtRaw) : null,
      processedAt:
          processedAtRaw is String ? DateTime.tryParse(processedAtRaw) : null,
      type: map['type'] as String?,
      error:
          errorRaw is Map<String, Object?> ? TaskError.fromMap(errorRaw) : null,
      details: map['details'] as Map<String, Object?>?,
    );
  }
}

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
}
