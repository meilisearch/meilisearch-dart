class PersonDto {
  static const kid = 'id';
  static const kname = 'name';

  final String id;
  final String name;

  final Map<String, Object?>? formatted;

  String get formattedTitle => formatted?[kname] as String? ?? name;

  const PersonDto({
    required this.id,
    required this.name,
    this.formatted,
  });

  Map<String, dynamic> toMap() {
    return {
      kid: id,
      kname: name,
    };
  }

  factory PersonDto.fromMap(Map<String, dynamic> map) {
    final formatted = map['_formatted'];
    return PersonDto(
      id: map[kid] as String,
      name: map[kname] as String,
      formatted: formatted is Map<String, Object?> ? formatted : null,
    );
  }
}
