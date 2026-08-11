class IndexStats {
  IndexStats({
    this.numberOfDocuments,
    this.isIndexing,
    this.fieldsDistribution,
    this.indexSize,
    this.usedIndexSize,
  });

  final int? numberOfDocuments;
  final bool? isIndexing;
  final Map<String, int>? fieldsDistribution;

  /// Size of the index database, in bytes.
  ///
  /// `null` when the Meilisearch instance is older than v1.53.0 and does not
  /// report it.
  final int? indexSize;

  /// Size of the used pages of the index database, in bytes.
  ///
  /// `null` when the Meilisearch instance is older than v1.53.0 and does not
  /// report it.
  final int? usedIndexSize;

  factory IndexStats.fromMap(Map<String, Object?> map) => IndexStats(
        numberOfDocuments: map['numberOfDocuments'] as int?,
        isIndexing: map['isIndexing'] as bool?,
        fieldsDistribution:
            (map['fieldsDistribution'] as Map?)?.cast<String, int>(),
        indexSize: map['indexSize'] as int?,
        usedIndexSize: map['usedIndexSize'] as int?,
      );
}
