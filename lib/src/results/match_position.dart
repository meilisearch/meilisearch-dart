class MatchPosition {
  final int start;
  final int length;

  const MatchPosition({
    required this.start,
    required this.length,
  });

  factory MatchPosition.fromMap(Map<String, dynamic> map) {
    return MatchPosition(
      start: map['start'] as int,
      length: map['length'] as int,
    );
  }
}
