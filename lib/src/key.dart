class Key {
  final String key;
  final String? description;
  final List<String> indexes;
  final List<String> actions;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Key(
      {this.key: "",
      this.description,
      this.actions: const ['*'],
      this.indexes: const ['*'],
      this.expiresAt,
      this.createdAt,
      this.updatedAt});

  factory Key.fromJson(Map<String, dynamic> json) => Key(
        description: json["description"],
        key: json["key"],
        actions: List<String>.from(json["actions"].map((x) => x)),
        indexes: List<String>.from(json["indexes"].map((x) => x)),
        expiresAt: DateTime.tryParse(json["expiresAt"] ?? ''),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
