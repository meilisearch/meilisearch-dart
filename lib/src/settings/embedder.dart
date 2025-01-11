import './distribution.dart';

abstract class Embedder {
  const Embedder();

  Map<String, Object?> toMap();

  factory Embedder.fromMap(Map<String, Object?> map) {
    final source = map['source'];

    return switch (source) {
      OpenAiEmbedder.source => OpenAiEmbedder.fromMap(map),
      HuggingFaceEmbedder.source => HuggingFaceEmbedder.fromMap(map),
      UserProvidedEmbedder.source => UserProvidedEmbedder.fromMap(map),
      RestEmbedder.source => RestEmbedder.fromMap(map),
      OllamaEmbedder.source => OllamaEmbedder.fromMap(map),
      _ => UnknownEmbedder(data: map),
    };
  }
}

class OpenAiEmbedder extends Embedder {
  static const source = 'openAi';
  final String? model;
  final String? apiKey;
  final String? documentTemplate;
  final int? dimensions;
  final DistributionShift? distribution;
  final String? url;
  final int? documentTemplateMaxBytes;
  final bool? binaryQuantized;

  const OpenAiEmbedder({
    this.model,
    this.apiKey,
    this.documentTemplate,
    this.dimensions,
    this.distribution,
    this.url,
    this.documentTemplateMaxBytes,
    this.binaryQuantized,
  });

  @override
  Map<String, Object?> toMap() => {
        'source': source,
        'model': model,
        'apiKey': apiKey,
        'documentTemplate': documentTemplate,
        'dimensions': dimensions,
        'distribution': distribution?.toMap(),
        'url': url,
        'documentTemplateMaxBytes': documentTemplateMaxBytes,
        'binaryQuantized': binaryQuantized,
      };

  factory OpenAiEmbedder.fromMap(Map<String, Object?> map) {
    final distribution = map['distribution'];

    return OpenAiEmbedder(
      model: map['model'] as String?,
      apiKey: map['apiKey'] as String?,
      documentTemplate: map['documentTemplate'] as String?,
      dimensions: map['dimensions'] as int?,
      distribution: distribution is Map<String, Object?>
          ? DistributionShift.fromMap(distribution)
          : null,
      url: map['url'] as String?,
      documentTemplateMaxBytes: map['documentTemplateMaxBytes'] as int?,
      binaryQuantized: map['binaryQuantized'] as bool?,
    );
  }
}

class HuggingFaceEmbedder extends Embedder {
  static const source = 'huggingFace';
  final String? model;
  final String? revision;
  final String? documentTemplate;
  final DistributionShift? distribution;
  final int? documentTemplateMaxBytes;
  final bool? binaryQuantized;

  const HuggingFaceEmbedder({
    this.model,
    this.revision,
    this.documentTemplate,
    this.distribution,
    this.documentTemplateMaxBytes,
    this.binaryQuantized,
  });

  @override
  Map<String, Object?> toMap() => {
        'source': source,
        'model': model,
        'documentTemplate': documentTemplate,
        'distribution': distribution?.toMap(),
        'documentTemplateMaxBytes': documentTemplateMaxBytes,
        'binaryQuantized': binaryQuantized,
      };

  factory HuggingFaceEmbedder.fromMap(Map<String, Object?> map) {
    final distribution = map['distribution'];

    return HuggingFaceEmbedder(
      model: map['model'] as String?,
      documentTemplate: map['documentTemplate'] as String?,
      distribution: distribution is Map<String, Object?>
          ? DistributionShift.fromMap(distribution)
          : null,
      documentTemplateMaxBytes: map['documentTemplateMaxBytes'] as int?,
      binaryQuantized: map['binaryQuantized'] as bool?,
    );
  }
}

class UserProvidedEmbedder extends Embedder {
  static const source = 'userProvided';
  final int dimensions;
  final DistributionShift? distribution;
  final bool? binaryQuantized;

  const UserProvidedEmbedder({
    required this.dimensions,
    this.distribution,
    this.binaryQuantized,
  });

  @override
  Map<String, Object?> toMap() => {
        'source': source,
        'dimensions': dimensions,
        'distribution': distribution?.toMap(),
        'binaryQuantized': binaryQuantized,
      };

  factory UserProvidedEmbedder.fromMap(Map<String, Object?> map) {
    final distribution = map['distribution'];

    return UserProvidedEmbedder(
      dimensions: map['dimensions'] as int,
      distribution: distribution is Map<String, Object?>
          ? DistributionShift.fromMap(distribution)
          : null,
      binaryQuantized: map['binaryQuantized'] as bool?,
    );
  }
}

class RestEmbedder extends Embedder {
  static const source = 'rest';
  final String url;
  final Map<String, Object?> request;
  final Map<String, Object?> response;
  final String? apiKey;
  final int? dimensions;
  final String? documentTemplate;
  final DistributionShift? distribution;
  final Map<String, Object?>? headers;
  final int? documentTemplateMaxBytes;
  final bool? binaryQuantized;

  const RestEmbedder({
    required this.url,
    required this.request,
    required this.response,
    this.apiKey,
    this.dimensions,
    this.documentTemplate,
    this.distribution,
    this.headers,
    this.documentTemplateMaxBytes,
    this.binaryQuantized,
  });

  @override
  Map<String, Object?> toMap() => {
        'source': source,
        'url': url,
        'request': request,
        'response': response,
        'apiKey': apiKey,
        'dimensions': dimensions,
        'documentTemplate': documentTemplate,
        'distribution': distribution?.toMap(),
        'headers': headers,
        'documentTemplateMaxBytes': documentTemplateMaxBytes,
        'binaryQuantized': binaryQuantized,
      };

  factory RestEmbedder.fromMap(Map<String, Object?> map) {
    final distribution = map['distribution'];

    return RestEmbedder(
      url: map['url'] as String,
      request: map['request'] as Map<String, Object?>,
      response: map['response'] as Map<String, Object?>,
      apiKey: map['apiKey'] as String?,
      dimensions: map['dimensions'] as int?,
      documentTemplate: map['documentTemplate'] as String?,
      distribution: distribution is Map<String, Object?>
          ? DistributionShift.fromMap(distribution)
          : null,
      headers: map['headers'] as Map<String, Object?>?,
      documentTemplateMaxBytes: map['documentTemplateMaxBytes'] as int?,
      binaryQuantized: map['binaryQuantized'] as bool?,
    );
  }
}

class OllamaEmbedder extends Embedder {
  static const source = 'ollama';
  final String? url;
  final String? apiKey;
  final String? model;
  final String? documentTemplate;
  final DistributionShift? distribution;
  final int? dimensions;
  final int? documentTemplateMaxBytes;
  final bool? binaryQuantized;

  const OllamaEmbedder({
    this.url,
    this.apiKey,
    this.model,
    this.documentTemplate,
    this.distribution,
    this.dimensions,
    this.documentTemplateMaxBytes,
    this.binaryQuantized,
  });

  @override
  Map<String, Object?> toMap() => {
        'source': source,
        'url': url,
        'apiKey': apiKey,
        'model': model,
        'documentTemplate': documentTemplate,
        'distribution': distribution?.toMap(),
        'dimensions': dimensions,
        'documentTemplateMaxBytes': documentTemplateMaxBytes,
        'binaryQuantized': binaryQuantized,
      };

  factory OllamaEmbedder.fromMap(Map<String, Object?> map) {
    final distribution = map['distribution'];

    return OllamaEmbedder(
      url: map['url'] as String?,
      apiKey: map['apiKey'] as String?,
      model: map['model'] as String?,
      documentTemplate: map['documentTemplate'] as String?,
      distribution: distribution is Map<String, Object?>
          ? DistributionShift.fromMap(distribution)
          : null,
      dimensions: map['dimensions'] as int?,
      documentTemplateMaxBytes: map['documentTemplateMaxBytes'] as int?,
      binaryQuantized: map['binaryQuantized'] as bool?,
    );
  }
}

class UnknownEmbedder extends Embedder {
  final Map<String, Object?> data;

  const UnknownEmbedder({
    required this.data,
  });

  @override
  Map<String, Object?> toMap() => data;

  factory UnknownEmbedder.fromMap(String source, Map<String, Object?> map) {
    return UnknownEmbedder(data: map);
  }
}
