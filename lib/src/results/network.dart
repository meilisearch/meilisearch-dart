import '../annotations.dart';

class _Unset {
  const _Unset();
}

const Object _unset = _Unset();

List<String>? _stringList(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is Iterable) {
    return raw.map((e) => e.toString()).toList();
  }
  return null;
}

Map<String, Object?>? _asObjectMap(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}

/// Remote Meilisearch instance in a [Network] topology.
@RequiredMeiliServerVersion('1.13.0')
class Remote {
  const Remote({
    this.url,
    this.searchApiKey,
    this.writeApiKey,
  });

  final String? url;
  final String? searchApiKey;
  final String? writeApiKey;

  factory Remote.fromMap(Map<String, Object?> map) {
    return Remote(
      url: map['url'] as String?,
      searchApiKey: map['searchApiKey'] as String?,
      writeApiKey: map['writeApiKey'] as String?,
    );
  }

  /// Fields to send in a PATCH body (sparse).
  Map<String, Object?> toPatchMap() {
    return <String, Object?>{
      if (url != null) 'url': url,
      if (searchApiKey != null) 'searchApiKey': searchApiKey,
      if (writeApiKey != null) 'writeApiKey': writeApiKey,
    };
  }
}

/// Shard ownership configuration within a [Network].
@RequiredMeiliServerVersion('1.13.0')
class Shard {
  const Shard({
    this.remotes,
    this.addRemotes,
    this.removeRemotes,
  });

  final List<String>? remotes;
  final List<String>? addRemotes;
  final List<String>? removeRemotes;

  factory Shard.fromMap(Map<String, Object?> map) {
    return Shard(
      remotes: _stringList(map['remotes']),
      addRemotes: _stringList(map['addRemotes']),
      removeRemotes: _stringList(map['removeRemotes']),
    );
  }

  Map<String, Object?> toPatchMap() {
    return <String, Object?>{
      if (remotes != null) 'remotes': remotes,
      if (addRemotes != null) 'addRemotes': addRemotes,
      if (removeRemotes != null) 'removeRemotes': removeRemotes,
    };
  }
}

/// Network topology returned by `GET /network` / `PATCH /network`.
@RequiredMeiliServerVersion('1.13.0')
class Network {
  const Network({
    this.self,
    this.leader,
    this.remotes,
    this.shards,
    this.previousRemotes,
    this.previousShards,
  });

  final String? self;
  final String? leader;
  final Map<String, Remote>? remotes;
  final Map<String, Shard>? shards;
  final Map<String, Remote>? previousRemotes;
  final Map<String, Shard>? previousShards;

  factory Network.fromMap(Map<String, Object?> json) {
    Map<String, Remote>? remotes;
    final remotesRaw = _asObjectMap(json['remotes']);
    if (remotesRaw != null) {
      remotes = remotesRaw.map(
        (k, v) => MapEntry(
          k,
          Remote.fromMap(Map<String, Object?>.from(v! as Map)),
        ),
      );
    }

    Map<String, Shard>? shards;
    final shardsRaw = _asObjectMap(json['shards']);
    if (shardsRaw != null) {
      shards = shardsRaw.map(
        (k, v) => MapEntry(
          k,
          Shard.fromMap(Map<String, Object?>.from(v! as Map)),
        ),
      );
    }

    Map<String, Remote>? previousRemotes;
    final prevRemotesRaw = _asObjectMap(json['previousRemotes']);
    if (prevRemotesRaw != null) {
      previousRemotes = prevRemotesRaw.map(
        (k, v) => MapEntry(
          k,
          Remote.fromMap(Map<String, Object?>.from(v! as Map)),
        ),
      );
    }

    Map<String, Shard>? previousShards;
    final prevShardsRaw = _asObjectMap(json['previousShards']);
    if (prevShardsRaw != null) {
      previousShards = prevShardsRaw.map(
        (k, v) => MapEntry(
          k,
          Shard.fromMap(Map<String, Object?>.from(v! as Map)),
        ),
      );
    }

    return Network(
      self: json['self'] as String?,
      leader: json['leader'] as String?,
      remotes: remotes,
      shards: shards,
      previousRemotes: previousRemotes,
      previousShards: previousShards,
    );
  }
}

/// Partial update payload for `PATCH /network`.
///
/// Omit a field to leave it unchanged. Pass [leader] or [self] as `null` to
/// clear. For [remotes] / [shards], pass a map; use `null` values for entries
/// to remove a remote or shard.
@RequiredMeiliServerVersion('1.13.0')
class UpdateNetworkOptions {
  UpdateNetworkOptions({
    Object? self = _unset,
    Object? leader = _unset,
    Object? remotes = _unset,
    Object? shards = _unset,
  })  : _self = self,
        _leader = leader,
        _remotes = remotes,
        _shards = shards;

  final Object? _self;
  final Object? _leader;
  final Object? _remotes;
  final Object? _shards;

  Map<String, Object?> toPatchMap() {
    final out = <String, Object?>{};
    if (!identical(_self, _unset)) {
      out['self'] = _self as String?;
    }
    if (!identical(_leader, _unset)) {
      out['leader'] = _leader as String?;
    }
    if (!identical(_remotes, _unset)) {
      final m = _remotes as Map<String, Remote?>?;
      if (m != null) {
        out['remotes'] = m.map(
          (k, v) => MapEntry(
            k,
            v?.toPatchMap(),
          ),
        );
      } else {
        out['remotes'] = null;
      }
    }
    if (!identical(_shards, _unset)) {
      final m = _shards as Map<String, Shard?>?;
      if (m != null) {
        out['shards'] = m.map(
          (k, v) => MapEntry(
            k,
            v?.toPatchMap(),
          ),
        );
      } else {
        out['shards'] = null;
      }
    }
    return out;
  }
}
