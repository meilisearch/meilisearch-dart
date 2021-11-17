class UpdateStatus {
  UpdateStatus({
    this.status,
    this.updateId,
    this.type,
    this.duration,
    this.enqueuedAt,
    this.processedAt,
    this.error,
  });

  final String? status;
  final int? updateId;
  final UpdateType? type;
  final double? duration;
  final DateTime? enqueuedAt;
  final DateTime? processedAt;
  final UpdateError? error;

  factory UpdateStatus.fromMap(Map<String, dynamic> map) => UpdateStatus(
      status: map['status'] as String?,
      updateId: map['updateId'] as int?,
      duration: map['duration'] as double?,
      enqueuedAt: map['enqueuedAt'] != null
          ? DateTime.tryParse(map['enqueuedAt'] as String)
          : null,
      processedAt: map['processedAt'] != null
          ? DateTime.tryParse(map['processedAt'] as String)
          : null,
      type: map['type'] != null
          ? UpdateType.fromMap(map['type'] as Map<String, dynamic>)
          : null,
      error: map['error'] != null
          ? UpdateError.fromMap(map['error'] as Map<String, dynamic>)
          : null);
}

class UpdateType {
  UpdateType({this.name, this.number});

  final String? name;
  final int? number;

  factory UpdateType.fromMap(Map<String, dynamic> map) => UpdateType(
        name: map['name'] as String?,
        number: map['number'] as int?,
      );
}

class UpdateError {
  UpdateError({
    this.message,
    this.code,
    this.type,
    this.link,
  });

  final String? message;
  final String? code;
  final String? type;
  final String? link;

  factory UpdateError.fromMap(Map<String, dynamic> map) => UpdateError(
        message: map['message'] as String?,
        code: map['code'] as String?,
        type: map['type'] as String?,
        link: map['link'] as String?,
      );
}
