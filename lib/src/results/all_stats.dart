import 'index_stats.dart';

class AllStats {
  AllStats({
    this.databaseSize,
    this.lastUpdate,
    this.indexes,
  });

  // Changed from int? to Object? to support both String (human format) and int (raw format)
  final Object? databaseSize;
  final DateTime? lastUpdate;
  final Map<String, IndexStats>? indexes;

  factory AllStats.fromMap(Map<String, Object?> json) {
    final lastUpdateRaw = json['lastUpdate'];
    final indexesRaw = json['indexes'];

    return AllStats(
      // Removed the 'as int?' cast so it safely parses either String or int
      databaseSize: json['databaseSize'],
      lastUpdate:
          lastUpdateRaw is String ? DateTime.tryParse(lastUpdateRaw) : null,
      indexes: indexesRaw is Map<String, Object?>
          ? indexesRaw
              .cast<String, Map<String, Object?>>()
              .map((k, v) => MapEntry(k, IndexStats.fromMap(v)))
          : null,
    );
  }
}