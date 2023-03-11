import 'package:meilisearch/src/min_word_size_for_typos.dart';

class TypoToleranceSettings {
  ///Enable the typo tolerance feature.
  bool enabled;

  ///Disable the typo tolerance feature on the specified attributes.
  List<String> disableOnAttributes;

  ///Disable the typo tolerance feature for a set of query terms given for a search query.
  List<String> disableOnWords;

  ///Customize the minimum size for a typo in a word
  MinWordSizeForTyposSettings? minWordSizeForTypos;

  TypoToleranceSettings({
    this.enabled = true,
    this.disableOnAttributes = const [],
    this.disableOnWords = const [],
    this.minWordSizeForTypos,
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'disableOnAttributes': disableOnAttributes,
      'disableOnWords': disableOnWords,
      'minWordSizeForTypos': minWordSizeForTypos?.toMap(),
    };
  }

  factory TypoToleranceSettings.fromMap(Map<String, dynamic> map) {
    final minWordSizeForTypos = map['minWordSizeForTypos'];
    return TypoToleranceSettings(
      enabled: map['enabled'] as bool? ?? true,
      disableOnAttributes:
          (map['disableOnAttributes'] as List?)?.cast<String>() ?? [],
      disableOnWords: (map['disableOnWords'] as List?)?.cast<String>() ?? [],
      minWordSizeForTypos: minWordSizeForTypos is Map<String, Object?>
          ? MinWordSizeForTyposSettings.fromMap(minWordSizeForTypos)
          : MinWordSizeForTyposSettings(),
    );
  }
}
