import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import '../http_request.dart';
import '../annotations.dart';

part 'experimental_features.g.dart';

@visibleForTesting
@JsonSerializable(
  createFactory: true,
  createToJson: false,
)
class ExperimentalFeatures {
  @JsonKey(name: 'vectorStore')
  final bool vectorStore;

  const ExperimentalFeatures({
    required this.vectorStore,
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

  const UpdateExperimentalFeatures({
    this.vectorStore,
  });

  Map<String, dynamic> toJson() => _$UpdateExperimentalFeaturesToJson(this);
}

extension ExperimentalFeaturesExt on HttpRequest {
  /// Get the status of all experimental features that can be toggled at runtime
  @RequiredMeiliServerVersion('1.3.0')
  @visibleForTesting
  Future<ExperimentalFeatures> getExperimentalFeatures() async {
    final response = await getMethod<Map<String, Object?>>(
      '/experimental-features',
    );
    return ExperimentalFeatures.fromJson(response.data!);
  }

  /// Set the status of experimental features that can be toggled at runtime
  @RequiredMeiliServerVersion('1.3.0')
  @visibleForTesting
  Future<ExperimentalFeatures> updateExperimentalFeatures(
    UpdateExperimentalFeatures input,
  ) async {
    final inputJson = input.toJson();
    if (inputJson.isEmpty) {
      throw ArgumentError.value(
        input,
        'input',
        'input must contain at least one entry',
      );
    }
    final response = await patchMethod<Map<String, Object?>>(
      '/experimental-features',
      data: input.toJson(),
    );
    return ExperimentalFeatures.fromJson(response.data!);
  }
}
