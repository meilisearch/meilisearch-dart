const _defaultmaxValuesPerFacet = 100;

class Faceting {
  //Define maximum number of value returned for a facet for a **search query**.
  //It means that with the default value of `100`,
  //it is not possible to have `101` different colors if the `color`` field is defined as a facet at search time.
  int maxValuesPerFacet;

  Faceting({
    this.maxValuesPerFacet = _defaultmaxValuesPerFacet,
  });

  Map<String, dynamic> toMap() {
    return {
      'maxValuesPerFacet': maxValuesPerFacet,
    };
  }

  factory Faceting.fromMap(Map<String, dynamic> map) {
    return Faceting(
      maxValuesPerFacet:
          map['maxValuesPerFacet'] as int? ?? _defaultmaxValuesPerFacet,
    );
  }
}
