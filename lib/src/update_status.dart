class UpdateStatus {
  UpdateStatus({
    this.status,
    this.updateId,
    this.type,
    this.duration,
    this.enqueuedAt,
    this.processedAt,
  });

  final String? status;
  final int? updateId;
  final UpdateType? type;
  final double? duration;
  final DateTime? enqueuedAt;
  final DateTime? processedAt;

  factory UpdateStatus.fromMap(Map<String, dynamic> map) => UpdateStatus(
        status: map['status'] as String,
        updateId: map['updateId'] as int,
        duration: map['duration'] as double,
        enqueuedAt: map['enqueuedAt'] != null
            ? DateTime.tryParse(map['enqueuedAt'] as String)
            : null,
        processedAt: map['processedAt'] != null
            ? DateTime.tryParse(map['processedAt'] as String)
            : null,
        type: map['type'] != null
            ? UpdateType.fromMap(map['type'] as Map<String, dynamic>)
            : null,
      );
}

class UpdateType {
  UpdateType({this.name, this.number});

  final String? name;
  final int? number;

  factory UpdateType.fromMap(Map<String, dynamic> map) => UpdateType(
        name: map['name'] as String,
        number: map['number'] as int,
      );
}
