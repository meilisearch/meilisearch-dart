const _defaultOneTypo = 5;
const _defaultTwoTypo = 9;

class MinWordSizeForTyposSettings {
  ///Customize the minimum size for a word to tolerate 1 typo.
  int oneTypo;

  ///Customize the minimum size for a word to tolerate 2 typo.
  int twoTypo;

  MinWordSizeForTyposSettings({
    this.oneTypo = _defaultOneTypo,
    this.twoTypo = _defaultTwoTypo,
  });

  Map<String, dynamic> toMap() {
    return {
      'oneTypo': oneTypo,
      'twoTypo': twoTypo,
    };
  }

  factory MinWordSizeForTyposSettings.fromMap(Map<String, dynamic> map) {
    return MinWordSizeForTyposSettings(
      oneTypo: map['oneTypo'] as int? ?? _defaultOneTypo,
      twoTypo: map['twoTypo'] as int? ?? _defaultTwoTypo,
    );
  }
}
