class Key {
  static const defaultActions = ["*"];
  static const defaultIndexes = ["*"];
  final String? uid;
  final String key;
  final String? name;
  final String? description;
  final List<String> indexes;
  final List<String> actions;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Key({
    this.uid = "",
    this.key = "",
    this.name,
    this.description,
    this.actions = defaultActions,
    this.indexes = defaultIndexes,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Key.fromJson(Map<String, Object?> json) {
    final actionsRaw = json["actions"];
    final indexesRaw = json["indexes"];
    final expiresAtRaw = json["expiresAt"];
    final createdAtRaw = json["createdAt"];
    final updatedAtRaw = json["updatedAt"];
    return Key(
      description: json["description"] as String?,
      key: json["key"] as String? ?? "",
      uid: json["uid"] as String?,
      actions: actionsRaw is Iterable
          ? List<String>.from(actionsRaw)
          : defaultActions,
      indexes: indexesRaw is Iterable
          ? List<String>.from(indexesRaw)
          : defaultIndexes,
      expiresAt:
          expiresAtRaw is String ? DateTime.tryParse(expiresAtRaw) : null,
      createdAt: createdAtRaw is String ? DateTime.parse(createdAtRaw) : null,
      updatedAt: updatedAtRaw is String ? DateTime.parse(updatedAtRaw) : null,
    );
  }
}
