import 'package:json_annotation/json_annotation.dart';

part 'experimental_features.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: false,
)
class ExperimentalFeatures {
  @JsonKey(name: 'vectorStore')
  final bool vectorStore;
  @JsonKey(name: 'scoreDetails')
  final bool scoreDetails;

  const ExperimentalFeatures({
    required this.vectorStore,
    required this.scoreDetails,
  });

  factory ExperimentalFeatures.fromJson(Map<String, dynamic> src) {
    return _$ExperimentalFeaturesFromJson(src);
  }
}

@JsonSerializable(
  includeIfNull: false,
  createToJson: true,
  createFactory: false,
)
class UpdateExperimentalFeatures {
  @JsonKey(name: 'vectorStore')
  final bool? vectorStore;
  @JsonKey(name: 'scoreDetails')
  final bool? scoreDetails;

  const UpdateExperimentalFeatures({
    this.vectorStore,
    this.scoreDetails,
  });

  Map<String, dynamic> toJson() => _$UpdateExperimentalFeaturesToJson(this);
}
