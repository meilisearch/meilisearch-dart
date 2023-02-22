class Key {
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
    this.actions = const ['*'],
    this.indexes = const ['*'],
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Key.fromJson(Map<String, Object?> json) => Key(
        description: json["description"] as String?,
        key: json["key"] as String? ?? "",
        uid: json["uid"] as String?,
        actions: json["actions"] is Iterable
            ? List<String>.from((json["actions"] as Iterable).cast<String>())
            : [],
        indexes: json["indexes"] is Iterable
            ? List<String>.from((json["indexes"] as Iterable).cast<String>())
            : [],
        expiresAt: json["expiresAt"] is String
            ? DateTime.tryParse(json["expiresAt"] as String)
            : null,
        createdAt: json["createdAt"] is String
            ? DateTime.parse(json["createdAt"] as String)
            : null,
        updatedAt: json["updatedAt"] is String
            ? DateTime.parse(json["updatedAt"] as String)
            : null,
      );
}
