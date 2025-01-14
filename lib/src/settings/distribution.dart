///  Describes the mean and sigma of distribution of embedding similarity in the embedding space.
///
/// The intended use is to make the similarity score more comparable to the regular ranking score.
/// This allows to correct effects where results are too "packed" around a certain value.
class DistributionShift {
  /// Value where the results are "packed".
  /// Similarity scores are translated so that they are packed around 0.5 instead
  final double mean;

  /// standard deviation of a similarity score.
  ///
  /// Set below 0.4 to make the results less packed around the mean, and above 0.4 to make them more packed.
  final double sigma;

  DistributionShift({
    required this.mean,
    required this.sigma,
  });

  factory DistributionShift.fromMap(Map<String, Object?> map) {
    return DistributionShift(
      mean: map['mean'] as double,
      sigma: map['sigma'] as double,
    );
  }

  Map<String, Object?> toMap() => {
        'mean': mean,
        'sigma': sigma,
      };
}
