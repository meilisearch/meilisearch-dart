import 'package:dio/dio.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

void main() {
  group('Network models', () {
    test('Network.fromMap parses self, leader, remotes, shards, previous*', () {
      final json = <String, Object?>{
        'self': 'ms-0',
        'leader': 'ms-0',
        'remotes': <String, Object?>{
          'ms-1': <String, Object?>{
            'url': 'http://localhost:7701',
            'searchApiKey': 'sk',
            'writeApiKey': 'wk',
          },
        },
        'shards': <String, Object?>{
          'shard-a': <String, Object?>{
            'remotes': <Object?>['ms-0', 'ms-1'],
          },
        },
        'previousRemotes': <String, Object?>{
          'old': <String, Object?>{'url': 'http://old'},
        },
        'previousShards': <String, Object?>{
          'shard-p': <String, Object?>{
            'remotes': <Object?>['ms-0'],
          },
        },
      };

      final n = Network.fromMap(json);

      expect(n.self, 'ms-0');
      expect(n.leader, 'ms-0');
      expect(n.remotes, isNotNull);
      expect(n.remotes!['ms-1']!.url, 'http://localhost:7701');
      expect(n.remotes!['ms-1']!.searchApiKey, 'sk');
      expect(n.remotes!['ms-1']!.writeApiKey, 'wk');

      expect(n.shards, isNotNull);
      expect(n.shards!['shard-a']!.remotes, ['ms-0', 'ms-1']);
      expect(n.shards!['shard-a']!.addRemotes, isNull);
      expect(n.shards!['shard-a']!.removeRemotes, isNull);

      expect(n.previousRemotes, isNotNull);
      expect(n.previousRemotes!['old']!.url, 'http://old');
      expect(n.previousShards, isNotNull);
      expect(n.previousShards!['shard-p']!.remotes, ['ms-0']);
    });

    test('Remote.toPatchMap is sparse', () {
      expect(
        const Remote(url: 'http://a').toPatchMap(),
        {'url': 'http://a'},
      );
      expect(
        Remote(
          url: 'http://a',
          searchApiKey: 's',
          writeApiKey: 'w',
        ).toPatchMap(),
        {
          'url': 'http://a',
          'searchApiKey': 's',
          'writeApiKey': 'w',
        },
      );
    });

    test('Shard.toPatchMap is sparse', () {
      expect(
        const Shard(addRemotes: ['a']).toPatchMap(),
        {
          'addRemotes': ['a']
        },
      );
      expect(
        const Shard(remotes: ['x'], removeRemotes: ['y']).toPatchMap(),
        {
          'remotes': ['x'],
          'removeRemotes': ['y'],
        },
      );
    });

    test('UpdateNetworkOptions builds partial PATCH bodies', () {
      expect(UpdateNetworkOptions().toPatchMap(), isEmpty);

      expect(
        UpdateNetworkOptions(self: 'node-1').toPatchMap(),
        {'self': 'node-1'},
      );

      expect(
        UpdateNetworkOptions(leader: null).toPatchMap(),
        {'leader': null},
      );

      expect(
        UpdateNetworkOptions(
          remotes: {
            'r1': const Remote(url: 'http://one'),
            'r2': null,
          },
        ).toPatchMap(),
        {
          'remotes': <String, Object?>{
            'r1': {'url': 'http://one'},
            'r2': null,
          },
        },
      );

      expect(
        UpdateNetworkOptions(
          shards: {
            's1': const Shard(addRemotes: ['a']),
          },
        ).toPatchMap(),
        {
          'shards': <String, Object?>{
            's1': {
              'addRemotes': ['a']
            },
          },
        },
      );
    });
  });

  group('MeiliSearchClient network', () {
    test('getNetwork uses GET /network', () async {
      final captured = <RequestOptions>[];
      final client = MeiliSearchClient.withCustomDio(
        'http://unit.test',
        apiKey: 'masterKey',
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              captured.add(options);
              handler.resolve(
                Response<Map<String, Object?>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: <String, Object?>{
                    'self': 'ms-0',
                    'remotes': <String, Object?>{},
                  },
                ),
              );
            },
          ),
        ],
      );

      final net = await client.getNetwork();

      expect(captured, hasLength(1));
      expect(captured.single.path, '/network');
      expect(captured.single.method, 'GET');
      expect(net.self, 'ms-0');
      expect(net.remotes, isNotNull);
      expect(net.remotes, isEmpty);
    });

    test('updateNetwork uses PATCH /network with body', () async {
      RequestOptions? last;
      final client = MeiliSearchClient.withCustomDio(
        'http://unit.test',
        apiKey: 'masterKey',
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              last = options;
              handler.resolve(
                Response<Map<String, Object?>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: <String, Object?>{
                    'self': 'x',
                    'remotes': <String, Object?>{},
                  },
                ),
              );
            },
          ),
        ],
      );

      await client.updateNetwork(UpdateNetworkOptions(self: 'x'));

      expect(last, isNotNull);
      expect(last!.path, '/network');
      expect(last!.method, 'PATCH');
      expect(last!.data, {'self': 'x'});
    });

    test('addRemote builds remotes patch entry', () async {
      Map<String, Object?>? data;
      final client = MeiliSearchClient.withCustomDio(
        'http://unit.test',
        apiKey: 'masterKey',
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              data = options.data as Map<String, Object?>?;
              handler.resolve(
                Response<Map<String, Object?>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: <String, Object?>{'remotes': <String, Object?>{}},
                ),
              );
            },
          ),
        ],
      );

      await client.addRemote(
        'peer',
        const Remote(url: 'http://peer:7700', searchApiKey: 'sk'),
      );

      expect(data, {
        'remotes': {
          'peer': {'url': 'http://peer:7700', 'searchApiKey': 'sk'},
        },
      });
    });

    test('removeRemote nulls remote entry', () async {
      Map<String, Object?>? data;
      final client = MeiliSearchClient.withCustomDio(
        'http://unit.test',
        apiKey: 'masterKey',
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              data = options.data as Map<String, Object?>?;
              handler.resolve(
                Response<Map<String, Object?>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: <String, Object?>{'remotes': <String, Object?>{}},
                ),
              );
            },
          ),
        ],
      );

      await client.removeRemote('peer');

      expect(data, {
        'remotes': {'peer': null},
      });
    });

    test('addRemotesToShard and removeRemotesFromShard', () async {
      final bodies = <Map<String, Object?>?>[];
      final client = MeiliSearchClient.withCustomDio(
        'http://unit.test',
        apiKey: 'masterKey',
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              bodies.add(options.data as Map<String, Object?>?);
              handler.resolve(
                Response<Map<String, Object?>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: <String, Object?>{'shards': <String, Object?>{}},
                ),
              );
            },
          ),
        ],
      );

      await client.addRemotesToShard('shard-1', ['a', 'b']);
      await client.removeRemotesFromShard('shard-1', ['a']);

      expect(bodies[0], {
        'shards': {
          'shard-1': {
            'addRemotes': ['a', 'b']
          },
        },
      });
      expect(bodies[1], {
        'shards': {
          'shard-1': {
            'removeRemotes': ['a']
          },
        },
      });
    });

    test('updateNetwork rejects empty patch', () async {
      final client = MeiliSearchClient.withCustomDio(
        'http://unit.test',
        apiKey: 'masterKey',
      );

      expect(
        () => client.updateNetwork(UpdateNetworkOptions()),
        throwsArgumentError,
      );
    });
  });
}
