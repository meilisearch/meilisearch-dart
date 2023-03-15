const _defaultOneTypo = 5;
const _defaultTwoTypo = 9;

class MinWordSizeForTypos {
  ///Customize the minimum size for a word to tolerate 1 typo.
  int oneTypo;

  ///Customize the minimum size for a word to tolerate 2 typo.
  int twoTypos;

  MinWordSizeForTypos({
    this.oneTypo = _defaultOneTypo,
    this.twoTypos = _defaultTwoTypo,
  });

  Map<String, dynamic> toMap() {
    return {
      'oneTypo': oneTypo,
      'twoTypos': twoTypos,
    };
  }

  factory MinWordSizeForTypos.fromMap(Map<String, dynamic> map) {
    return MinWordSizeForTypos(
      oneTypo: map['oneTypo'] as int? ?? _defaultOneTypo,
      twoTypos: map['twoTypos'] as int? ?? _defaultTwoTypo,
    );
  }
}
