class HybridSearch {
  final String embedder;
  final double semanticRatio;

  const HybridSearch({
    required this.embedder,
    required this.semanticRatio,
  }) : assert(
          semanticRatio >= 0.0 && semanticRatio <= 1.0,
          "'semanticRatio' must be between 0.0 and 1.0",
        );

  Map<String, Object?> toMap() => {
        'embedder': embedder,
        'semanticRatio': semanticRatio,
      };
}
