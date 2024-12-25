class HybridSearch {
  final String embedder;
  final double semanticRatio;

  const HybridSearch({
    required this.embedder,
    required this.semanticRatio,
  }) : assert(
          semanticRatio > 0.0 && semanticRatio < 1.0,
          "'semanticRatio' must be greater than 0.0 and less than 1.0",
        );

  Map<String, Object?> toMap() => {
        'embedder': embedder,
        'semanticRatio': semanticRatio,
      };
}
