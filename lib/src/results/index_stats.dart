class IndexStats {
  IndexStats({
    this.numberOfDocuments,
    this.isIndexing,
    this.fieldsDistribution,
    this.internalDatabaseSizes, // Added this field to the constructor
  });

  final int? numberOfDocuments;
  final bool? isIndexing;
  final Map<String, int>? fieldsDistribution;
  
  // Added this field to capture the dictionary of internal database component sizes
  final Map<String, Object?>? internalDatabaseSizes;

  factory IndexStats.fromMap(Map<String, Object?> map) => IndexStats(
        numberOfDocuments: map['numberOfDocuments'] as int?,
        isIndexing: map['isIndexing'] as bool?,
        fieldsDistribution:
            (map['fieldsDistribution'] as Map?)?.cast<String, int>(),
        // Safely parses internalDatabaseSizes if present
        internalDatabaseSizes:
            (map['internalDatabaseSizes'] as Map?)?.cast<String, Object?>(),
      );
}