const _defaultOneTypo = 5;
const _defaultTwoTypo = 9;

class MinWordSizeForTypos {
  ///Customize the minimum size for a word to tolerate 1 typo.
  int oneTypo;

  ///Customize the minimum size for a word to tolerate 2 typo.
  int twoTypo;

  MinWordSizeForTypos({
    this.oneTypo = _defaultOneTypo,
    this.twoTypo = _defaultTwoTypo,
  });

  Map<String, dynamic> toMap() {
    return {
      'oneTypo': oneTypo,
      'twoTypo': twoTypo,
    };
  }

  factory MinWordSizeForTypos.fromMap(Map<String, dynamic> map) {
    return MinWordSizeForTypos(
      oneTypo: map['oneTypo'] as int? ?? _defaultOneTypo,
      twoTypo: map['twoTypo'] as int? ?? _defaultTwoTypo,
    );
  }
}
