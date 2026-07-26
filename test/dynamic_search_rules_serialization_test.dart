import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

// Serialization / query-body coverage for the Dynamic Search Rules
// endpoints introduced in Meilisearch v1.50.0. These tests intentionally
// don't touch the network — an experimental server-side flag is required
// to exercise the endpoints against a live Meilisearch, and the API shape
// is what breaks first when the server evolves.

void main() {
  group('DynamicSearchRule.fromJson', () {
    test('parses every documented field including nested conditions/actions',
        () {
      final json = <String, Object?>{
        'uid': 'black-friday',
        'description': 'Black Friday 2025 rules',
        'precedence': 10,
        'active': true,
        'conditions': <String, Object?>{
          'query': <String, Object?>{'isEmpty': true},
          'time': <String, Object?>{
            'start': '2025-11-28T00:00:00Z',
            'end': '2025-11-28T23:59:59Z',
          },
        },
        'actions': <Object?>[
          <String, Object?>{
            'selector': <String, Object?>{
              'indexUid': 'products',
              'id': '123',
            },
            'action': <String, Object?>{
              'type': 'pin',
              'position': 1,
            },
          },
        ],
        'createdAt': '2025-11-01T12:34:56Z',
        'updatedAt': '2025-11-02T10:00:00Z',
      };

      final rule = DynamicSearchRule.fromJson(json);

      expect(rule.uid, 'black-friday');
      expect(rule.description, 'Black Friday 2025 rules');
      expect(rule.precedence, 10);
      expect(rule.active, isTrue);

      expect(rule.conditions, isNotNull);
      final query = rule.conditions!['query'] as Map<String, Object?>;
      expect(query['isEmpty'], isTrue);

      expect(rule.actions, isNotNull);
      expect(rule.actions!.length, 1);
      final firstAction = rule.actions!.first;
      final selector = firstAction['selector'] as Map<String, Object?>;
      expect(selector['indexUid'], 'products');
      final action = firstAction['action'] as Map<String, Object?>;
      expect(action['type'], 'pin');
      expect(action['position'], 1);

      expect(rule.createdAt, DateTime.parse('2025-11-01T12:34:56Z'));
      expect(rule.updatedAt, DateTime.parse('2025-11-02T10:00:00Z'));
    });

    test('handles a sparse response without exploding', () {
      final rule = DynamicSearchRule.fromJson(
        const <String, Object?>{'uid': 'minimal'},
      );

      expect(rule.uid, 'minimal');
      expect(rule.description, isNull);
      expect(rule.precedence, isNull);
      expect(rule.active, isNull);
      expect(rule.conditions, isNull);
      expect(rule.actions, isNull);
      expect(rule.createdAt, isNull);
      expect(rule.updatedAt, isNull);
    });

    test('accepts an unparseable timestamp by leaving it null (not throwing)',
        () {
      final rule = DynamicSearchRule.fromJson(<String, Object?>{
        'uid': 'x',
        'createdAt': 'not-a-date',
      });

      expect(rule.createdAt, isNull);
    });
  });

  group('DynamicSearchRule.toUpsertBody', () {
    test('emits only the fields the caller set (sparse PATCH)', () {
      final rule = DynamicSearchRule(
        uid: 'ignored-when-upserting',
        precedence: 5,
      );

      final body = rule.toUpsertBody();

      expect(body.keys, unorderedEquals(<String>['precedence']));
      expect(body['precedence'], 5);
    });

    test('serializes conditions and actions verbatim', () {
      final rule = DynamicSearchRule(
        uid: 'x',
        description: 'test',
        active: true,
        conditions: const <String, Object?>{
          'query': <String, Object?>{'isEmpty': true},
        },
        actions: const <Map<String, Object?>>[
          <String, Object?>{
            'selector': <String, Object?>{'indexUid': 'i', 'id': '1'},
            'action': <String, Object?>{'type': 'pin', 'position': 1},
          },
        ],
      );

      final body = rule.toUpsertBody();

      expect(body['description'], 'test');
      expect(body['active'], isTrue);
      expect(body['conditions'], isA<Map<String, Object?>>());
      expect((body['actions'] as List).length, 1);
    });
  });

  group('DynamicSearchRulesQuery.toBody', () {
    test('empty query serializes to an empty body', () {
      expect(const DynamicSearchRulesQuery().toBody(), isEmpty);
    });

    test('offset/limit round-trip', () {
      const q = DynamicSearchRulesQuery(offset: 20, limit: 5);
      expect(q.toBody(), <String, Object?>{'offset': 20, 'limit': 5});
    });

    test('filter object round-trip carries query + active', () {
      const q = DynamicSearchRulesQuery(
        limit: 10,
        filter: DynamicSearchRulesFilter(query: 'black friday', active: true),
      );
      expect(q.toBody(), <String, Object?>{
        'limit': 10,
        'filter': <String, Object?>{
          'query': 'black friday',
          'active': true,
        },
      });
    });

    test('an entirely empty filter object is dropped from the body', () {
      const q = DynamicSearchRulesQuery(
        filter: DynamicSearchRulesFilter(),
      );
      expect(q.toBody(), isEmpty);
    });

    test('sparse filter with only one field only emits that field', () {
      const q = DynamicSearchRulesQuery(
        filter: DynamicSearchRulesFilter(active: false),
      );
      expect(q.toBody(), <String, Object?>{
        'filter': <String, Object?>{'active': false},
      });
    });
  });
}
