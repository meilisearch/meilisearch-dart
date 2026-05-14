import 'package:dio/dio.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/results/experimental_features.dart';
import 'package:test/test.dart';

void main() {
  group('network / useNetwork serialization', () {
    test('UpdateExperimentalFeatures(network: true) serializes network', () {
      expect(
        UpdateExperimentalFeatures(network: true).toJson(),
        {'network': true},
      );
    });

    test('SearchQuery(useNetwork: true) includes useNetwork in toSparseMap',
        () {
      expect(
        SearchQuery(useNetwork: true).toSparseMap(),
        containsPair('useNetwork', true),
      );
    });

    test(
      'IndexSearchQuery(indexUid, useNetwork: true) includes useNetwork in toSparseMap',
      () {
        expect(
          IndexSearchQuery(
            indexUid: 'movies',
            useNetwork: true,
          ).toSparseMap(),
          containsPair('useNetwork', true),
        );
      },
    );

    test(
      'index.search sends useNetwork in POST body with SearchQuery',
      () async {
        Map<String, Object?>? body;
        final client = MeiliSearchClient.withCustomDio(
          'http://unit.test',
          apiKey: 'masterKey',
          interceptors: [
            InterceptorsWrapper(
              onRequest: (options, handler) {
                body = options.data as Map<String, Object?>?;
                handler.resolve(
                  Response<Map<String, Object?>>(
                    requestOptions: options,
                    statusCode: 200,
                    data: <String, Object?>{
                      'hits': <Object?>[],
                      'processingTimeMs': 0,
                    },
                  ),
                );
              },
            ),
          ],
        );

        await client.index('movies').search(
              'hello',
              const SearchQuery(useNetwork: true),
            );

        expect(body, isNotNull);
        expect(body!['q'], 'hello');
        expect(body!['useNetwork'], true);
      },
    );

    test(
      'multiSearch sends useNetwork inside each queries[] entry',
      () async {
        Map<String, Object?>? body;
        final client = MeiliSearchClient.withCustomDio(
          'http://unit.test',
          apiKey: 'masterKey',
          interceptors: [
            InterceptorsWrapper(
              onRequest: (options, handler) {
                body = options.data as Map<String, Object?>?;
                handler.resolve(
                  Response<Map<String, Object?>>(
                    requestOptions: options,
                    statusCode: 200,
                    data: <String, Object?>{
                      'results': <Object?>[
                        <String, Object?>{
                          'indexUid': 'movies',
                          'hits': <Object?>[],
                          'processingTimeMs': 0,
                        },
                      ],
                    },
                  ),
                );
              },
            ),
          ],
        );

        await client.multiSearch(
          MultiSearchQuery(
            queries: [
              const IndexSearchQuery(
                indexUid: 'movies',
                query: 'nemo',
                useNetwork: true,
              ),
            ],
          ),
        );

        expect(body, isNotNull);
        final queries = body!['queries'] as List<Object?>?;
        expect(queries, hasLength(1));
        final first = queries!.single as Map<String, Object?>;
        expect(first['indexUid'], 'movies');
        expect(first['q'], 'nemo');
        expect(first['useNetwork'], true);
      },
    );

    test('MultiSearchQuery propagates useNetwork via queries sparse maps', () {
      final sparse = MultiSearchQuery(
        queries: [
          const IndexSearchQuery(
            indexUid: 'movies',
            query: 'x',
            useNetwork: true,
          ),
        ],
      ).toSparseMap();

      final queries = sparse['queries'] as List<Object?>?;
      expect(queries, hasLength(1));
      expect(
        queries!.single as Map<String, Object?>,
        containsPair('useNetwork', true),
      );
    });
  });
}
