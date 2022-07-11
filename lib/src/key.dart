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

  Key(
      {this.uid: "",
      this.key: "",
      this.name: null,
      this.description,
      this.actions: const ['*'],
      this.indexes: const ['*'],
      this.expiresAt,
      this.createdAt,
      this.updatedAt});

  factory Key.fromJson(Map<String, dynamic> json) => Key(
        description: json["description"],
        key: json["key"],
        uid: json["uid"],
        actions: List<String>.from(json["actions"].map((x) => x)),
        indexes: List<String>.from(json["indexes"].map((x) => x)),
        expiresAt: DateTime.tryParse(json["expiresAt"] ?? ''),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
