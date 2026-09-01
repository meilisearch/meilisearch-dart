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
  final int? indexSize;
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
