import '../annotations.dart';

@RequiredMeiliServerVersion('1.3.0')
class FacetHit {
  final String value;
  final int count;

  const FacetHit({
    required this.value,
    required this.count,
  });

  factory FacetHit.fromMap(Map<String, dynamic> map) {
    return FacetHit(
      value: map['value'] as String,
      count: map['count'] as int,
    );
  }
}
