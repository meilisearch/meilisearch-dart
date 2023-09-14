// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experimental_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperimentalFeatures _$ExperimentalFeaturesFromJson(
        Map<String, dynamic> json) =>
    ExperimentalFeatures(
      vectorStore: json['vectorStore'] as bool,
      scoreDetails: json['scoreDetails'] as bool,
    );

Map<String, dynamic> _$UpdateExperimentalFeaturesToJson(
    UpdateExperimentalFeatures instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('vectorStore', instance.vectorStore);
  writeNotNull('scoreDetails', instance.scoreDetails);
  return val;
}
