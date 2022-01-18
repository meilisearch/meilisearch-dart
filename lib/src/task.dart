class Task {
  Task({
    this.status,
    this.uid,
    this.type,
    this.duration,
    this.enqueuedAt,
    this.processedAt,
    this.error,
    this.details,
  });

  final String? status;
  final int? uid;
  final String? type;
  final String? duration;
  final DateTime? enqueuedAt;
  final DateTime? processedAt;
  final TaskError? error;
  final Map<String, dynamic>? details;

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        status: map['status'] as String?,
        uid: map['uid'] as int?,
        duration: map['duration'] as String?,
        enqueuedAt: map['enqueuedAt'] != null
            ? DateTime.tryParse(map['enqueuedAt'] as String)
            : null,
        processedAt: map['processedAt'] != null
            ? DateTime.tryParse(map['processedAt'] as String)
            : null,
        type: map['type'] as String?,
        error: map['error'] != null
            ? TaskError.fromMap(map['error'] as Map<String, dynamic>)
            : null,
        details: map['details'],
      );
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

  factory TaskError.fromMap(Map<String, dynamic> map) => TaskError(
        message: map['message'] as String?,
        code: map['code'] as String?,
        type: map['type'] as String?,
        link: map['link'] as String?,
      );
}
