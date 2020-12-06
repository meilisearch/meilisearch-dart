typedef MapSerializer<T> = Map<String, dynamic> Function(T object);
typedef MapDeserializer<T> = T Function(Map<String, dynamic> map);

/// Interface for (de)serializing Map types into custom object types.
///
/// Used for mapping json data from http responses into dart objects or vice
/// versa.
abstract class Serializer<T> {
  factory Serializer({
    MapSerializer<T> serializer,
    MapDeserializer<T> deserializer,
  }) = _Serializer;

  static const defaultSerializer = _MapSerializer();

  /// Deserializes object from given [map].
  T deserialize(Map<String, dynamic> map);

  /// Serializes [object] into Map.
  Map<String, dynamic> serialize(T object);
}

class _Serializer<T> implements Serializer<T> {
  _Serializer({this.serializer, this.deserializer});

  final MapSerializer<T> serializer;
  final MapDeserializer<T> deserializer;

  @override
  T deserialize(map) => deserializer(map);

  @override
  serialize(T object) => serializer(object);
}

class _MapSerializer implements Serializer<Map<String, dynamic>> {
  const _MapSerializer();

  @override
  deserialize(map) => map;

  @override
  serialize(object) => object;
}
