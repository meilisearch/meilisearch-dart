class UpdateStatus {
  UpdateStatus({
    this.status,
    this.updateId,
    this.type,
    this.duration,
    this.enqueuedAt,
    this.processedAt,
  });

  final String status;
  final int updateId;
  final UpdateType type;
  final double duration;
  final DateTime enqueuedAt;
  final DateTime processedAt;

  factory UpdateStatus.fromMap(Map<String, dynamic> map) => UpdateStatus(
        status: map['status'] as String,
        updateId: map['updateId'] as int,
        duration: map['duration'] as double,
        enqueuedAt: DateTime.tryParse(map['enqueuedAt'] as String),
        processedAt: DateTime.tryParse(map['processedAt'] as String),
        type: UpdateType.fromMap(map['type'] as Map<String, dynamic>),
      );
}

class UpdateType {
  UpdateType({this.name, this.number});

  final String name;
  final int number;

  factory UpdateType.fromMap(Map<String, dynamic> map) => UpdateType(
        name: map['name'] as String,
        number: map['number'] as int,
      );
}
