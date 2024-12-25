class Distribution {
  final double mean;
  final double sigma;

  Distribution({
    required this.mean,
    required this.sigma,
  });

  factory Distribution.fromMap(Map<String, Object?> map) {
    return Distribution(
      mean: map['mean'] as double,
      sigma: map['sigma'] as double,
    );
  }

  Map<String, Object?> toMap() => {
        'mean': mean,
        'sigma': sigma,
      };
}
