class IndexStats {
  IndexStats({
    this.numberOfDocuments,
    this.isIndexing,
    this.fieldsDistribution,
  });

  final int? numberOfDocuments;
  final bool? isIndexing;
  final Map<String, int>? fieldsDistribution;

  factory IndexStats.fromMap(Map<String, Object?> map) => IndexStats(
        numberOfDocuments: map['numberOfDocuments'] as int?,
        isIndexing: map['isIndexing'] as bool?,
        fieldsDistribution:
            (map['fieldsDistribution'] as Map?)?.cast<String, int>(),
      );
}

class AllStats {
  AllStats({
    this.databaseSize,
    this.lastUpdate,
    this.indexes,
  });

  final int? databaseSize;
  final DateTime? lastUpdate;
  final Map<String, IndexStats>? indexes;

  factory AllStats.fromMap(Map<String, Object?> json) {
    final Object? lastUpdateRaw = json['lastUpdate'];
    final DateTime? lastUpdate =
        lastUpdateRaw is String ? DateTime.tryParse(lastUpdateRaw) : null;
    final Map<String, IndexStats> indexes =
        (json['indexes'] as Map<String, Object?>?)
                ?.cast<String, Map<String, Object?>>()
                .map((k, v) => MapEntry(k, IndexStats.fromMap(v))) ??
            {};

    return AllStats(
      databaseSize: json['databaseSize'] as int?,
      lastUpdate: lastUpdate,
      indexes: indexes,
    );
  }
}
